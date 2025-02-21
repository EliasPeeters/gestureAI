//
//  LessonOverviewView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct LessonOverviewView: View {
    @StateObject private var progressManager = LessonProgressManager()

    @State private var lessons: [Lesson] = [
        Lesson(
            id: "1",
            title: "A, B, D",
            isUnlocked: true,
            tasks: [
                Task(
                    type: .imageToText,
                    question: "Welcher Buchstabe ist das?",
                    options: ["A", "B", "C"],
                    correctAnswer: "A",
                    imageName: "a"
                )
            ]
        ),
        Lesson(id: "2", title: "A, B, D alt", isUnlocked: true, tasks: [
            Task(type: .imageToText, question: "Welcher Buchstabe ist das?", options: ["A", "B", "C"], correctAnswer: "A"),
            Task(type: .imageToText, question: "Welche Buchstabe ist das? 2", options: ["A", "B", "C"], correctAnswer: "A"),
            Task(type: .textToImage, question: "Zeige das A", options: ["img_a", "img_b", "img_c"], correctAnswer: "img_a"),
            Task(type: .imageToText, question: "Welche Buchstabe ist das jetzt?", options: ["A", "B", "C"], correctAnswer: "A"),
            Task(type: .aiGesture, question: "Mache ein A mit der Hand", options: [], correctAnswer: "A"),
            Task(type: .textToImage, question: "Zeige das A", options: ["img_a", "img_b", "img_c"], correctAnswer: "img_a"),
        ]),
        Lesson(id: "3", title: "D, E, F", isUnlocked: false, tasks: [])
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(lessons, id: \.id) { lesson in
                            NavigationLink(destination: LessonDetailView(lesson: lesson, progressManager: progressManager)) {
                                LessonRowView(lesson: lesson, isCompleted: progressManager.isLessonCompleted(lesson))
                            }
                            .disabled(!lesson.isUnlocked)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Lektionspfad")
        }
        .onAppear {
            updateUnlockedLessons()
        }
    }

    private func updateUnlockedLessons() {
        for i in lessons.indices {
            if progressManager.isLessonCompleted(lessons[i]), i + 1 < lessons.count {
                lessons[i + 1].isUnlocked = true
            }
        }
    }
}
