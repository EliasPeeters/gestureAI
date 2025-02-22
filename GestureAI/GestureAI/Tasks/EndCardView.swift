//
//  EndCardView.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

import SwiftUI

struct EndCardView: View {
    let imageName: String
    let value: String
    let label: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
