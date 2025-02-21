//
//  AIGestureTaskView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct AIGestureTaskView: View {
    let task: Task
    var onNext: (Bool) -> Void

    var body: some View {
        VStack {
            Text(task.question)
                .font(.headline)
                .padding()

            Text("Hier wird die Kamera eingebunden.")
                .padding()
            
            Button("Weiter") {
                onNext(true)
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // ⬅️ Aufgabe auf ganze Breite und Höhe setzen
        .padding()
    }
}
