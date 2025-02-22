from fastapi import FastAPI, File, UploadFile
import cv2
import numpy as np
import mediapipe as mp
import joblib
from io import BytesIO
from PIL import Image, ExifTags
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

# FastAPI-Instanz erstellen
app = FastAPI()

# MediaPipe initialisieren
mp_hands = mp.solutions.hands

# ML-Modell laden (Pfad beachten!)
model = joblib.load("model/asl_model.pkl")

# Google Gesture Recognizer Modell initialisieren
base_options = python.BaseOptions(model_asset_path='model/gesture_recognizer.task')
options = vision.GestureRecognizerOptions(base_options=base_options)
recognizer = vision.GestureRecognizer.create_from_options(options)

# Mapping für Gesten
gesture_mapping = {
    "Closed_Fist": "A",
    "Victory": "V",
    "Pointing_Up": "D"
}

def extract_hand_landmarks(image):
    """ Extrahiert Handlandmarken aus einem Bild. """
    with mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.7) as hands:
        results = hands.process(image)
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                return np.array([[lm.x for lm in hand_landmarks.landmark] +
                                 [lm.y for lm in hand_landmarks.landmark] +
                                 [lm.z for lm in hand_landmarks.landmark]])
    return None

@app.get("/")
async def read_root():
    return {"Hello": "World"}

@app.post("/predict")
async def predict_hand_sign(file: UploadFile = File(...)):
    """ Empfängt ein Bild, analysiert das Handzeichen und gibt den Buchstaben zurück. """
    # Bild einlesen
    contents = await file.read()
    image = Image.open(BytesIO(contents))
    image = image.convert("RGB")  # Sicherstellen, dass das Bild RGB ist
    image = np.array(image)

    if len(image.shape) < 3:
        return {"error": "Ungültiges Bildformat"}

    # Falls Bild 4 Kanäle (RGBA) hat, auf 3 Kanäle (RGB) reduzieren
    if image.shape[-1] == 4:
        image = cv2.cvtColor(image, cv2.COLOR_RGBA2RGB)

    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    # Handlandmarken extrahieren
    landmarks = extract_hand_landmarks(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    if landmarks is None:
        return {"error": "Keine Hand erkannt"}

    # Vorhersage mit ML-Modell
    prediction = model.predict(landmarks)[0]

    return {"prediction": prediction}

@app.post("/v2/predict")
async def predict_hand_sign_v2(file: UploadFile = File(...)):
    """ Empfängt ein Bild und analysiert die Geste mit dem Google-Modell. """
    # Bild einlesen
    contents = await file.read()
    image = Image.open(BytesIO(contents))

    # EXIF-Daten auslesen und Bild korrekt drehen
    try:
        for orientation in ExifTags.TAGS.keys():
            if ExifTags.TAGS[orientation] == "Orientation":
                break
        exif = image._getexif()
        if exif is not None:
            orientation = exif.get(orientation, None)
            if orientation == 3:
                image = image.rotate(180, expand=True)
            elif orientation == 6:
                image = image.rotate(270, expand=True)
            elif orientation == 8:
                image = image.rotate(90, expand=True)
    except Exception as e:
        print(f"EXIF-Fehler: {e}")

    image = image.convert("RGB")  # Sicherstellen, dass das Bild RGB ist
    image = np.array(image)

    if len(image.shape) < 3:
        return {"error": "Ungültiges Bildformat"}

    # Falls Bild 4 Kanäle (RGBA) hat, auf 3 Kanäle (RGB) reduzieren
    if image.shape[-1] == 4:
        image = cv2.cvtColor(image, cv2.COLOR_RGBA2RGB)
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    # Debug: Speichern des Bildes zum Testen
    cv2.imwrite("/app/debug_image.jpg", image)

    # Sicherstellen, dass das Bild als numpy-Array vorliegt
    if image is None or image.size == 0:
        return {"error": "Fehler beim Laden des Bildes"}

    # MediaPipe Image erzeugen mit der korrekten Methode
    try:
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    except Exception as e:
        return {"error": f"Fehler bei der Konvertierung: {str(e)}"}

    # Erkenne Geste mit MediaPipe Gesture Recognizer
    recognition_result = recognizer.recognize(mp_image)
    if not recognition_result.gestures:
        return {"error": "Keine Geste erkannt"}

    # Übersetzung der erkannten Geste
    top_gesture = recognition_result.gestures[0][0].category_name
    mapped_gesture = gesture_mapping.get(top_gesture, "Keine Hand erkannt")

    return {"gesture": mapped_gesture}
