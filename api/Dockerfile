# Basis-Image mit Python 3.9
FROM python:3.9

# Arbeitsverzeichnis im Container erstellen
WORKDIR /app

# Notwendige Bibliotheken installieren (Fix für OpenCV)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0

# Abhängigkeiten kopieren und installieren
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# API-Code kopieren
COPY api.py .
COPY model/asl_model.pkl model/

# Port freigeben
EXPOSE 8000

# API starten
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]