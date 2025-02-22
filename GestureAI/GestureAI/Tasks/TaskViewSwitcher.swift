//
//  TaskViewSwitcher.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//

import SwiftUI

// Aufgabe-View Umschalter mit Animation
struct TaskViewSwitcher: View {
    let task: SingleTask
    var onNext: (Bool, Int) -> Void
    @State private var showNewTask = false
    
    var body: some View {
        ZStack {
            getTaskView(task)
                .id(task.id) // 💡 Neue Aufgabe wird als eigenständige View erkannt
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                )) // 🔄 Sanfter Wechsel bei unterschiedlichen Typen
                .animation(.easeInOut(duration: 0.4), value: task.id)
        }
        .onChange(of: task) { _ in
            withAnimation {
                showNewTask.toggle()
            }
        }
    }
    
    // Funktion zur Rückgabe der richtigen View je nach Task-Typ
    @ViewBuilder
    private func getTaskView(_ task: SingleTask) -> some View {
        switch task.type {
        case .imageToText:
            ImageToTextTaskView(task: task, onNext: onNext)
        case .textToImage:
            TextToImageTaskView(task: task, onNext: onNext)
        case .introduce:
            IntroduceTaskView(task: task, onNext: onNext)
        case .aiGesture:
            AIGestureTaskView(task: task, onNext: onNext)
        }
    }
}
