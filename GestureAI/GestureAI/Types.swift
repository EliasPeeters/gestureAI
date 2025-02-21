//
//  Types.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//

import Foundation


// Modell für eine Aufgabe
enum TaskType: String, Codable {
    case imageToText  // Bild → richtige Antwort wählen
    case textToImage  // Text → richtiges Bild wählen
    case aiGesture    // Kamera → KI erkennt Geste
}

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    let type: TaskType
    let question: String
    let options: [String] // Mögliche Antworten (für Typ A & B)
    let correctAnswer: String
    let imageName: String? // ✅ Optionales Feld für Aufgaben mit Bild

    // ✅ Equatable-Konformität implementieren
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(type: TaskType, question: String, options: [String], correctAnswer: String, imageName: String? = nil) {
            self.id = UUID()
            self.type = type
            self.question = question
            self.options = options
            self.correctAnswer = correctAnswer
            self.imageName = (type == .imageToText) ? imageName : nil // ✅ Nur für imageToText
        }
}

struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    var isUnlocked: Bool
    var tasks: [Task]

    init(id:String, title: String, isUnlocked: Bool, tasks: [Task]) {
        self.id = id
        self.title = title
        self.isUnlocked = isUnlocked
        self.tasks = tasks
    }
}
