//
//  LessonsDetailView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//

import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    @ObservedObject var progressManager: LessonProgressManager
    @State private var currentTaskIndex = 0
    @State private var startTime = Date()
    @State private var score = 0
    @State private var mistakes = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var showExitConfirmation = false
    
    var progress: CGFloat {
        guard !lesson.tasks.isEmpty else { return 0 }
        return CGFloat(currentTaskIndex) / CGFloat(lesson.tasks.count)
    }
    
    var timeElapsed: String {
        let elapsed = Int(Date().timeIntervalSince(startTime))
        let minutes = elapsed / 60
        let seconds = elapsed % 60
        return "\(minutes) min \(seconds) sec"
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                if currentTaskIndex < lesson.tasks.count {
                    let task = lesson.tasks[currentTaskIndex]
                    TaskViewSwitcher(task: task, onNext: { isCorrect in
                        if isCorrect {
                            score += 5
                        } else {
                            mistakes += 1
                        }
                        currentTaskIndex += 1
                    })
                } else {
                    EndScreenView(lesson: lesson, score: score, mistakes: mistakes, timeElapsed: timeElapsed, progressManager: progressManager)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    Button(action: {
                        showExitConfirmation = true
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    Text(lesson.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Spacer()
                    Rectangle()
                        .frame(width: 15, height: 20)
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ProgressBarView(progress: progress)
                    .frame(maxWidth: .infinity) // Maximale Breite setzen
                    .frame(height: 10) // Höhe separat setzen
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showExitConfirmation) {
            Alert(
                title: Text("Lektion abbrechen?"),
                message: Text("Dein Fortschritt in dieser Lektion geht verloren. Möchtest du wirklich abbrechen?"),
                primaryButton: .destructive(Text("Ja, beenden")) {
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Weiter lernen"))
            )
        }
    }
}
