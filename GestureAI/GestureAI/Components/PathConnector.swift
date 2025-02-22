//
//  PathConnector.swift
//  GestureAI
//
//  Created by Elias Peeters on 21.02.25.
//


import SwiftUI

struct PathConnector: View {
    let start: CGPoint
    let end: CGPoint
    let positionType: Int // 0 = Mitte → Links, 1 = Links → Mitte, 2 = Mitte → Rechts, 3 = Rechts → Mitte

    var body: some View {
        Path { path in
            path.move(to: start)

            let arcRadius = abs(start.x - end.x) / 2 // **Größe des Viertelkreises**
            let centerX = (start.x + end.x) / 2
            let centerY = (start.y + end.y) / 2

            switch positionType {
            case 0: // **Mitte → Links (Viertelkreis nach links)**
                path.addArc(
                    center: CGPoint(x: start.x - arcRadius, y: start.y),
                    radius: arcRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: true
                )
            case 1: // **Links → Mitte (Viertelkreis nach unten)**
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: arcRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: true
                )
            case 2: // **Mitte → Rechts (Viertelkreis nach rechts)**
                path.addArc(
                    center: CGPoint(x: start.x + arcRadius, y: start.y),
                    radius: arcRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(0),
                    clockwise: false
                )
            case 3: // **Rechts → Mitte (Viertelkreis nach unten)**
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: arcRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false
                )
            default:
                break
            }
        }
        .stroke(Color.yellow, style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [10, 15])) // ✅ Gepunktete Linie bleibt
    }
}
