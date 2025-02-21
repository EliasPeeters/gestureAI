//
//  TextToImageTaskView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct TextToImageTaskView: View {
    let task: Task
    var onNext: (Bool) -> Void

    var body: some View {
        VStack {
            Text(task.question)
                .font(.headline)
                .padding()

            ForEach(task.options, id: \.self) { option in
                Button(option) {
                    if option == task.correctAnswer {
                        onNext(true)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // ⬅️ Aufgabe auf ganze Breite und Höhe setzen
        .padding()
    }
}
