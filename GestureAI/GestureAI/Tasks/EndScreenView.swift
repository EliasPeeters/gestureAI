//
//  EndScreenView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct EndScreenView: View {
    let lesson: Lesson
    let score: Int
    let mistakes: Int
    let timeElapsed: String
    @ObservedObject var progressManager: LessonProgressManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Lektion abgeschlossen!")
                .font(.title)
                .bold()

            HStack(spacing: 20) {
                EndCardView(title: "⏳ Zeit", value: timeElapsed)
                EndCardView(title: "🏆 Punkte", value: "\(score)")
                EndCardView(title: "❌ Fehler", value: "\(mistakes)")
            }

            Button(action: {
                progressManager.completeLesson(lesson)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Zurück zum Hauptmenü")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}
