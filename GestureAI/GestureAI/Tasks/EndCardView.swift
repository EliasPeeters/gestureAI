//
//  EndCardView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct EndCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title)
                .bold()
        }
        .frame(width: 100, height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}