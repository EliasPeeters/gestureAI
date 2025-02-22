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
        Lesson(id: "0", title: "Welcome", isUnlocked: true, tasks: [
            SingleTask(
                type: .introduce,
                question: "Welcome to HandsUp",
                options: [],
                correctAnswer: "",
                imageName: "AppIcon",
                points: 0,
                text: "With HandsUp you can learn the alphabet in sign language! Sign language is an important communication tool for many people worldwide. Let's get started!"
            ),
            SingleTask(
                type: .introduce,
                question: "Why learn Sign Language?",
                options: [],
                correctAnswer: "",
                imageName: "sign_language_world",
                points: 0,
                text: "Over 70 million people worldwide use sign language as their primary means of communication. Learning sign language helps break communication barriers and fosters inclusivity."
            )
        ], image: "start"),
        Lesson(id: "1", title: "Your first Letter: A", isUnlocked: false, tasks: [
            SingleTask(
                type: .introduce,
                question: "The letter A",
                options: [],
                correctAnswer: "gesture_a",
                imageName: "gesture_a",
                points: 0,
                text: "This is how you sign the letter A in sign language. Try to remember it!"
            ),
            SingleTask(
                type: .textToImage,
                question: "Which one is A?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_a",
                points: 5
            ),
            SingleTask(
                type: .aiGesture,
                question: "Make an A with your hand",
                options: [],
                correctAnswer: "A",
                points: 10
            ),
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D"],
                correctAnswer: "A",
                imageName: "gesture_a",
                points: 5
            )
        ], image: "gesture_a"),
        
        Lesson(id: "2", title: "Next letter: B", isUnlocked: false, tasks: [
            SingleTask(
                type: .introduce,
                question: "The letter B",
                options: [],
                correctAnswer: "gesture_b",
                imageName: "gesture_b",
                points: 0,
                text: "This is how you sign the letter B in sign language. Try it out!"
            ),
            SingleTask(
                type: .aiGesture,
                question: "Make a B with your hand",
                options: [],
                correctAnswer: "B",
                points: 10
            ),
            SingleTask(
                type: .textToImage,
                question: "Which one is B?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_b",
                points: 5
            ),
            SingleTask(
                type: .textToImage,
                question: "Still remember letter A?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_a",
                points: 5
            ),
        ], image: "gesture_b"),
        
        Lesson(id: "3", title: "Recognizing A and B", isUnlocked: false, tasks: [
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D"],
                correctAnswer: "A",
                imageName: "gesture_a",
                points: 5
            ),
            SingleTask(
                type: .aiGesture,
                question: "Make a B with your hand",
                options: [],
                correctAnswer: "B",
                points: 10
            ),
            SingleTask(
                type: .textToImage,
                question: "Which one is A?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_a",
                points: 5
            ),
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D"],
                correctAnswer: "B",
                imageName: "gesture_b",
                points: 5
            )
        ], image: "gesture_a"),
        
        Lesson(id: "5", title: "The letter D", isUnlocked: false, tasks: [
            SingleTask(
                type: .introduce,
                question: "The letter D",
                options: [],
                correctAnswer: "gesture_d",
                imageName: "gesture_d",
                points: 0,
                text: "This is how you sign the letter D in sign language. Try it yourself!"
            ),
            SingleTask(
                type: .aiGesture,
                question: "Make a D with your hand",
                options: [],
                correctAnswer: "D",
                points: 10
            ),
            SingleTask(
                type: .textToImage,
                question: "Which one is D?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_d",
                points: 5
            )
        ], image: "gesture_d"),
        
        Lesson(id: "6", title: "The letter V", isUnlocked: false, tasks: [
            SingleTask(
                type: .introduce,
                question: "The letter V",
                options: [],
                correctAnswer: "gesture_v",
                imageName: "gesture_v",
                points: 0,
                text: "This is how you sign the letter V in sign language. Give it a try!"
            ),
            SingleTask(
                type: .aiGesture,
                question: "Make a V with your hand",
                options: [],
                correctAnswer: "V",
                points: 10
            ),
            SingleTask(
                type: .textToImage,
                question: "Which one is V?",
                options: ["gesture_a", "gesture_b", "gesture_d", "gesture_v"],
                correctAnswer: "gesture_v",
                points: 5
            )
        ], image: "gesture_v"),
        
        Lesson(id: "7", title: "Final Review", isUnlocked: false, tasks: [
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D", "V"],
                correctAnswer: "A",
                imageName: "gesture_a",
                points: 5
            ),
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D", "V"],
                correctAnswer: "B",
                imageName: "gesture_b",
                points: 5
            ),
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D", "V"],
                correctAnswer: "D",
                imageName: "gesture_d",
                points: 5
            ),
            SingleTask(
                type: .imageToText,
                question: "What letter is this?",
                options: ["A", "B", "D", "V"],
                correctAnswer: "V",
                imageName: "gesture_v",
                points: 5
            )
        ], image: "review")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.customGreen.ignoresSafeArea()

                VStack(spacing: 16) {
                    ProfileHeaderView(progressManager: progressManager)

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                                let isUnlocked = progressManager.isLessonUnlocked(lesson, in: lessons)
                                let isCompleted = progressManager.isLessonCompleted(lesson)

                                ZStack(alignment: .leading) {
                                    if index > 0 {
                                        Rectangle()
                                            .frame(width: 4, height: 49)
                                            .foregroundColor(isUnlocked ? .green : .white)
                                            .offset(x: 81, y: -57)
                                    }

                                    NavigationLink(destination: LessonDetailView(lesson: lesson, progressManager: progressManager)) {
                                        LessonRowView(lesson: lesson, isCompleted: isCompleted, isUnlocked: isUnlocked, imageName: lesson.image)
                                    }
                                    .disabled(!isUnlocked)
                                    .padding(16)
                                }
                            }
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 20)
                    }
                    .background(
                        Color(red: 0.95, green: 0.95, blue: 0.95)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .ignoresSafeArea() // <-- Diese Zeile sicherstellen
                    )
                }
            }
        }
        .onAppear {
            updateUnlockedLessons()
        }
    }
    
    // 🔄 Berechnet Position für Lektionen (Mitte → Links → Mitte → Rechts → Mitte)
    private func getLessonPosition(index: Int) -> CGPoint {
        let yOffset = CGFloat(index) * 150 + 100 // Abstand zwischen Lektionen
        let screenWidth = UIScreen.main.bounds.width
        let xOffset: CGFloat

        switch index % 4 {
        case 0: xOffset = screenWidth / 2  // Mitte
        case 1: xOffset = screenWidth / 4  // Links
        case 2: xOffset = screenWidth / 2  // Mitte
        case 3: xOffset = 3 * screenWidth / 4  // Rechts
        default: xOffset = screenWidth / 2
        }

        return CGPoint(x: xOffset, y: yOffset)
    }
    
    private func updateUnlockedLessons() {
        for i in lessons.indices {
            if progressManager.isLessonCompleted(lessons[i]), i + 1 < lessons.count {
                lessons[i + 1].isUnlocked = true
            }
        }
    }
}
