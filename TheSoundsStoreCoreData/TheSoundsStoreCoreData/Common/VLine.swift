//
//  VLine.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct VLine: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
    
    func stroked(lineWidth: CGFloat = 1, dash: [CGFloat] = [5]) -> some Shape {
        return self.stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
    }
    
    func doted(lineWidth: CGFloat = 1, dash: [CGFloat] = [5]) -> some Shape {
        return self.stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
    }
    
}
