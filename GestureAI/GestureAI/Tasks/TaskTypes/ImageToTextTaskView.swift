//
//  ImageToTextTaskView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct ImageToTextTaskView: View {
    let task: SingleTask
    var onNext: (Bool, Int) -> Void // ✅ Übergeben, ob Antwort richtig oder falsch war

    @State private var selectedOption: String? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showCorrectAnswer = false

    var body: some View {
        VStack {
            Text(task.question)
                .font(.headline)
                .padding()
            
            if let imageName = task.imageName {
                Image(imageName)
                    .frame(width: 150, height: 150)
                    .padding()
            }

            ForEach(task.options, id: \.self) { option in
                Button(action: {
                    if selectedOption == nil { // Verhindert mehrfaches Klicken
                        selectedOption = option
                        isCorrect = (option == task.correctAnswer)
                        showCorrectAnswer = true

                        // 🔄 Automatische Weiterleitung nach 1 Sekunde
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            onNext(isCorrect ?? false, task.points)
                        }
                    }
                }) {
                    Text(option)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(getButtonColor(for: option))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .animation(.easeInOut, value: isCorrect) // 🔥 Weicher Farbübergang
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // ✅ Funktion zur Bestimmung der Button-Farbe
    private func getButtonColor(for option: String) -> Color {
        if selectedOption == nil {
            return Color.blue // Standardfarbe
        }
        if option == selectedOption {
            return isCorrect == true ? Color.customGreen : Color.customRed // ✅ oder ❌
        }
        if showCorrectAnswer && option == task.correctAnswer {
            return Color.green.opacity(0.5) // 🔎 Korrekte Antwort leicht hervorheben
        }
        return Color.blue
    }
}
