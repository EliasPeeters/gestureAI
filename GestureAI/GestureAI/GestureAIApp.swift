//
//  GestureAIApp.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//

import SwiftUI

@main
struct GestureAIApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.red.ignoresSafeArea() // ✅ Hintergrundfarbe für gesamte App
                LessonOverviewView()
            }
        }
    }
}
