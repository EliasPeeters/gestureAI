//
//  ProgressBarView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct ProgressBarView: View {
    var progress: CGFloat // Fortschritt als Wert zwischen 0 und 1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Hintergrund der Progress-Bar
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 10)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                // Fortschrittsbalken (animiert)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width * progress, height: 10)
                    .foregroundColor(Color.customGreen)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 10)
    }
}
