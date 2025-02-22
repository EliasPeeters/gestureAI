//
//  APIService.swift
//  GestureAI
//
//  Created by Elias Peeters on 22.02.25.
//


import Foundation
import UIKit

class APIService {
    private let baseURL = "https://gesture.eliaspeeters.de"
    
    func uploadImage(_ image: UIImage) async throws -> String {
        print("🔍 Start: Bild-Upload Prozess")
        
        let startTime = Date() // Startzeit erfassen
        
        // Optimiere Bildgröße
        let optimizedImage = image.preparingForUpload()
        
        guard let url = URL(string: "\(baseURL)/predict") else {
            print("❌ Fehler: Ungültige URL")
            throw URLError(.badURL)
        }
        
        // Konvertiere UIImage zu JPEG-Daten mit geringerer Qualität
        guard let imageData = optimizedImage.jpegData(compressionQuality: 0.5) else {
            print("❌ Fehler: Bildkonvertierung fehlgeschlagen")
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fehler bei der Bildkonvertierung"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30 // Erhöhe Timeout auf 30 Sekunden
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
    
        do {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 30
            let session = URLSession(configuration: config)
            
            let (data, response) = try await session.data(for: request)
            
            let duration = Date().timeIntervalSince(startTime) // Dauer berechnen
            print("⏱️ Dauer des Requests: \(duration) Sekunden")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Fehler: Keine HTTP Response")
                throw URLError(.badServerResponse)
            }
            
            print("📊 Status Code: \(httpResponse.statusCode)")
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("❌ Server Error: Status \(httpResponse.statusCode)")
                if let errorText = String(data: data, encoding: .utf8) {
                    print("Server Antwort: \(errorText)")
                }
                throw URLError(.badServerResponse)
            }
            
            guard let result = String(data: data, encoding: .utf8) else {
                print("❌ Fehler: Konnte Response nicht als String lesen")
                throw NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fehler beim Lesen der Antwort"])
            }
            
            return result
            
        } catch {
            print("❌ Netzwerk-Fehler: \(error)")
            throw error
        }
    }
}

// Extension für Bildoptimierung
extension UIImage {
    func preparingForUpload() -> UIImage {
        let maxDimension: CGFloat = 300
        let scale = min(maxDimension / size.width, maxDimension / size.height, 1.0)
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let optimizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return optimizedImage
    }
}
