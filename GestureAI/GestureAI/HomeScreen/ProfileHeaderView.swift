//
//  ProfileHeaderView.swift
//  GestureAI
//
//  Created by Elias Peeters on 22.02.25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var progressManager: LessonProgressManager

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: ProfileView()) {
                        Image("IconHandsUp")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Welcome to")
            
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("HandsUp")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }

                HStack(spacing: 16) { // ✅ Spacing für die Spalte zwischen den Boxen
                    InfoBox(imageName: "points", value: "\(progressManager.getPoints())", label: "Points")
                    InfoBox(imageName: "tasks", value: "\(progressManager.getCompletedLessonsCount())", label: "Lessons")
                }
            }
            Spacer()
        }
        .padding(30)
        .background(Color.customGreen.opacity(0.8))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}
