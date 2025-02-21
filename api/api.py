from fastapi import FastAPI, File, UploadFile
import cv2
import numpy as np
import mediapipe as mp
import joblib
from io import BytesIO
from PIL import Image

# FastAPI-Instanz erstellen
app = FastAPI()

# MediaPipe initialisieren
mp_hands = mp.solutions.hands

# ML-Modell laden (Pfad beachten!)
model = joblib.load("model/asl_model.pkl")

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
    image = np.array(image)

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
