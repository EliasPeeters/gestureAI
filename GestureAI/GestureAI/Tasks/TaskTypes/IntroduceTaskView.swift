//
//  IntroduceGesture.swift
//  GestureAI
//
//  Created by Elias Peeters on 22.02.25.
//

//
//  TextToImageTaskView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct IntroduceTaskView: View {
    let task: SingleTask
    var onNext: (Bool, Int) -> Void // ✅ Callback für richtig/falsch
    
    var body: some View {
        VStack {
            Text(task.question)
                .font(.title)
                .padding()
            
            if let taskText = task.text {
                Text(taskText)
                    .font(.headline)
                    .padding()
            }
            
            if let imageName = task.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit() // Stellt sicher, dass das Bild das Seitenverhältnis beibehält
                    .frame(width: UIScreen.main.bounds.width * 0.6,
                           height: UIScreen.main.bounds.width * 0.6) // Quadratisch
                    .foregroundColor(.white)
                    .padding(10)
            }
            
            Button(action: {
                onNext(true, task.points)
            }) {
                Text("Weiter")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
