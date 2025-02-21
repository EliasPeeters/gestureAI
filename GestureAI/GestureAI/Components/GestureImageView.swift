//
//  GestureImageView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct GestureImageView: View {
    let letter: String

    var body: some View {
        Image(getGestureImageName(for: letter))
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }

    // Funktion zur Zuordnung von Buchstaben zu Bildnamen
    private func getGestureImageName(for letter: String) -> String {
        return "gesture_\(letter.lowercased())" // Beispiel: "gesture_a"
    }
}