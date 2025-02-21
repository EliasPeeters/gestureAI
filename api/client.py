import cv2
import requests
import time

API_URL = "http://localhost:8000/predict/"

cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("Fehler: Kamera konnte nicht geöffnet werden.")
    exit()

print("📸 Kamera gestartet. Drücke 'q', um zu beenden...")

while True:
    ret, frame = cap.read()
    if not ret:
        print("Fehler: Konnte kein Bild aufnehmen.")
        break

    image_path = "temp_frame.jpg"
    cv2.imwrite(image_path, frame)

    with open(image_path, "rb") as file:
        response = requests.post(API_URL, files={"file": file})

    if response.status_code == 200:
        result = response.json()
        prediction = result.get("prediction", "Unbekannt")
    else:
        prediction = "Fehler bei API"

    cv2.putText(frame, f"Zeichen: {prediction}", (50, 50),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    cv2.imshow("ASL-Erkennung", frame)

    time.sleep(1)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print("🚪 Programm beendet.")
