import SwiftUI
import AVFoundation

struct AIGestureTaskView: View {
    let task: SingleTask
    var onNext: (Bool, Int) -> Void
    
    @State private var recognizedLetter: String = "⏳" // Letzte erkannte Prediction
    @State private var isTaskCompleted = false // Status, ob Aufgabe abgeschlossen ist

    var body: some View {
        VStack {
            Text(task.question)
                .font(.largeTitle)
                .padding()

            ZStack {
                CameraView(recognizedLetter: $recognizedLetter,
                           correctAnswer: task.correctAnswer,
                           isTaskCompleted: $isTaskCompleted)
                    .background(Color.customGreen)
                    .frame(width: .infinity)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                // Graue Overlay-Schicht mit "Abgeschlossen"-Text
                if isTaskCompleted {
                    Color.black.opacity(0.5) // Halbtransparente graue Schicht
                        .cornerRadius(20)
                        .overlay(
                            Text("✅ Aufgabe abgeschlossen!")
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                        )
                        .frame(width: .infinity, height: 300)
                        .transition(.opacity)
                }
            }
            .padding()

            if isTaskCompleted {
                Button(action: {
                    onNext(true, task.points)
                }) {
                    Text("Weiter")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            } else {
                Button(action: {
                    onNext(false, task.points)
                }) {
                    Text("Überspringen")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondaryGray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var recognizedLetter: String
    let correctAnswer: String
    @Binding var isTaskCompleted: Bool

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.recognizedLetterBinding = $recognizedLetter
        controller.correctAnswer = correctAnswer
        controller.isTaskCompletedBinding = $isTaskCompleted
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput = AVCapturePhotoOutput()
    var recognizedLetterBinding: Binding<String>?
    var isTaskCompletedBinding: Binding<Bool>?
    var correctAnswer: String = ""
    private let squareContainerView = UIView()
    
    private var isRunning = true // 🛑 Kontrolliert, ob Anfragen noch gesendet werden sollen

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(squareContainerView)
        setupCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        squareContainerView.frame = view.bounds

        squareContainerView.layer.cornerRadius = 20
        squareContainerView.layer.masksToBounds = true  // Wichtig für Sublayer-Clipping

        previewLayer.frame = squareContainerView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopImageCaptureLoop() // 🛑 Stoppt Schleife, wenn View geschlossen wird
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ Keine Kamera gefunden")
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                self.startImageCaptureLoop()
            }
        } catch {
            print("❌ Fehler beim Einrichten der Kamera: \(error.localizedDescription)")
        }
    }

    private func startImageCaptureLoop() {
        DispatchQueue.global(qos: .userInitiated).async {
            while self.isRunning { // 🛑 Läuft nur, solange die Bedingung erfüllt ist
                if let isTaskCompleted = self.isTaskCompletedBinding?.wrappedValue, isTaskCompleted {
                    print("✅ Aufgabe ist abgeschlossen. Beende API-Anfragen.")
                    return
                }

                self.captureAndSendImage()
                sleep(1) // ⏳ 1 Sekunde Pause nach jeder API-Antwort
            }
        }
    }

    private func stopImageCaptureLoop() {
        isRunning = false
        print("🛑 API-Schleife gestoppt (View geschlossen oder Aufgabe abgeschlossen).")
    }

    private func captureAndSendImage() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off

        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    private func sendImageToAPI(imageData: Data) {
        let url = URL(string: "https://gesture.eliaspeeters.de/predict")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"gesture.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Fehler bei API-Anfrage: \(error.localizedDescription)")
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                print("❌ Fehler beim Verarbeiten der API-Antwort: Keine gültigen Daten erhalten")
                return
            }

            // 🔹 Log der rohen API-Response
            print("📝 API Response (roh): \(responseString)")

            // 🟢 JSON parsen
            if let prediction = self.parsePrediction(from: data) {
                DispatchQueue.main.async {
                    self.recognizedLetterBinding?.wrappedValue = prediction

                    // ✅ Überprüfen, ob Prediction der erwarteten Antwort entspricht
                    if prediction == self.correctAnswer {
                        self.isTaskCompletedBinding?.wrappedValue = true
                        self.stopImageCaptureLoop() // 🛑 Stoppt API-Schleife nach Erfolg
                    }
                }
            }
        }
        task.resume()
    }

    private func parsePrediction(from data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let errorMessage = json["error"] as? String {
                    print("⚠️ API Error: \(errorMessage)")
                    return nil // ❌ Ignoriert Fehler und behält den letzten erkannten Buchstaben
                }
                return json["prediction"] as? String
            }
        } catch {
            print("❌ Fehler beim JSON-Parsing: \(error.localizedDescription)")
        }
        return nil
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("❌ Fehler beim Aufnehmen des Fotos: \(error!.localizedDescription)")
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            print("❌ Konnte Bilddaten nicht extrahieren")
            return
        }

        sendImageToAPI(imageData: imageData)
    }
}
