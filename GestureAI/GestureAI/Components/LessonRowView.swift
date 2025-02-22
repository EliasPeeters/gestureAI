//
//  Less.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    let isCompleted: Bool
    let isUnlocked: Bool
    let imageName: String

    var body: some View {
        HStack(spacing: 16) {
            // 🔹 Bild oder Icon (kann vom Nutzer bestimmt werden)
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(8) // ✅ Fügt Innenabstand hinzu
                .background(Color.white) // Falls du einen Hintergrund haben willst
                .clipShape(Circle())
                .overlay(Circle().stroke(isUnlocked ? Color.green : Color.gray, lineWidth: 2))
            
            VStack(alignment: .leading) {
                Text(lesson.title)
                    .font(.headline)
                    .foregroundColor(isUnlocked ? .black : .white)
                if isCompleted {
                    Text("abgeschlossen")
                }
            }
            Spacer()
        }
        .padding()
        .background(isUnlocked ? Color.white : Color.gray.opacity(1)) // ✅ Hintergrundfarbe explizit setzen
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}
