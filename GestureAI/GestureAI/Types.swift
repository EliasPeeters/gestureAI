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
    case introduce
}

struct SingleTask: Identifiable, Codable, Equatable {
    var id = UUID()
    let type: TaskType
    let question: String
    let text: String?
    let options: [String] // ✅ Wird jetzt für ALLE Aufgabenarten verwendet
    let correctAnswer: String
    let imageName: String? // ✅ Optional für imageToText
    let points: Int

    // ✅ Equatable-Konformität
    static func == (lhs: SingleTask, rhs: SingleTask) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(type: TaskType, question: String, options: [String], correctAnswer: String, imageName: String? = nil, points: Int, text: String? = nil) {
        self.id = UUID()
        self.type = type
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.imageName = imageName
        self.points = points
        self.text = text
    }
}

struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    let image: String
    var isUnlocked: Bool
    var tasks: [SingleTask]

    init(id:String, title: String, isUnlocked: Bool, tasks: [SingleTask], image:String) {
        self.id = id
        self.title = title
        self.isUnlocked = isUnlocked
        self.tasks = tasks
        self.image = image
    }
}
