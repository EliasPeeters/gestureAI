//
//  TextToImageTaskView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct TextToImageTaskView: View {
    let task: SingleTask
    var onNext: (Bool, Int) -> Void // ✅ Callback für richtig/falsch

    @State private var selectedOption: String? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showCorrectAnswer = false

    var body: some View {
        VStack {
            Text(task.question)
                .font(.headline)
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) { // ✅ 2x2 Grid für die Bilder
                ForEach(task.options, id: \.self) { imageName in
                    Button(action: {
                        if selectedOption == nil { // ✅ Verhindert mehrfaches Klicken
                            selectedOption = imageName
                            isCorrect = (imageName == task.correctAnswer)
                            showCorrectAnswer = true

                            // 🔄 Automatische Weiterleitung nach 1 Sekunde
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                onNext(isCorrect ?? false, task.points)
                            }
                        }
                    }) {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                            .background(getButtonColor(for: imageName)) // ✅ Hintergrundfarbe basierend auf Richtigkeit
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // ✅ Funktion zur Bestimmung der Button-Farbe
    private func getButtonColor(for option: String) -> Color {
        if selectedOption == nil {
            return Color.clear // Standardfarbe
        }
        if option == selectedOption {
            return isCorrect == true ? Color.customGreen : Color.customRed // ✅ oder ❌
        }
        if showCorrectAnswer && option == task.correctAnswer {
            return Color.green.opacity(0.5) // 🔎 Richtige Antwort leicht hervorheben
        }
        return Color.clear
    }
}
