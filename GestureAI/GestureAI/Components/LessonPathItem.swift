//
//  LessonPathItem.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct LessonPathItem: View {
    let lesson: Lesson
    let isUnlocked: Bool
    let isCompleted: Bool

    var body: some View {
        VStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : (isUnlocked ? "circle.fill" : "lock.fill"))
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(isUnlocked ? (isCompleted ? .yellow : .green) : .gray)
                .background(isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                .clipShape(Circle())

            Text(lesson.title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(width: 100)
        .padding()
    }
}
