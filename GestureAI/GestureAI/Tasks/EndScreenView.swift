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
    @ObservedObject var progressManager: LessonProgressManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Lektion abgeschlossen!")
                .font(.title)
                .bold()

//            HStack(spacing: 10) { // Abstand von 10 px
//                        EndCardView(title: "🏆 Punkte", value: "\(score)")
//                        EndCardView(title: "❌ Fehler", value: "\(mistakes)")
//                    }
//                    .padding(.horizontal, 10) // Optional: zusätzlicher Rand
//
            
            HStack(spacing: 16) { // ✅ Spacing für die Spalte zwischen den Boxen
                EndCardView(imageName: "points", value: "\(score)", label: "Points")
                EndCardView(imageName: "mistake", value: "\(mistakes)", label: "Mistakes")
            }

            Button(action: {
                progressManager.completeLesson(lesson)
                progressManager.addPoints(score)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Finish lesson")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}
