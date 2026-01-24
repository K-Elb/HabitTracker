//
//  Weight.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 23/01/2026.
//

import SwiftUI

struct WeightParameters {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }

    static let segments = [
        Segment(
            line:    CGPoint(x: 0.30, y: 0.20),
            curve:   CGPoint(x: 0.20, y: 0.30),
            control: CGPoint(x: 0.22, y: 0.20)
        ),
        Segment(
            line:    CGPoint(x: 0.1, y: 0.9),
            curve:   CGPoint(x: 0.2, y: 1.0),
            control: CGPoint(x: 0.08, y: 1.0)
        ),
        Segment(
            line:    CGPoint(x: 0.80, y: 1.0),
            curve:   CGPoint(x: 0.90, y: 0.90),
            control: CGPoint(x: 0.92, y: 1.0)
        ),
        Segment(
            line:    CGPoint(x: 0.80, y: 0.3),
            curve:   CGPoint(x: 0.70, y: 0.2),
            control: CGPoint(x: 0.78, y: 0.20)
        )
    ]
}

struct Weight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.7, y: height * 0.2))
        
        path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.2))
        path.addCurve(to: CGPoint(x: width * 0.4, y: height * 0.2), control1: CGPoint(x: width * 0.7, y: height * -0.05), control2: CGPoint(x: width * 0.3, y: height * -0.05))
        
        WeightParameters.segments.forEach { segment in
            path.addLine(to: CGPoint(
                x: width * segment.line.x,
                y: height * segment.line.y)
            )
            
            path.addQuadCurve(to: CGPoint(
                x: width * segment.curve.x,
                y: height * segment.curve.y
            ),control: CGPoint(
                x: width * segment.control.x,
                y: height * segment.control.y)
            )
        }
        
        path.closeSubpath()
        
        let rect3 = CGRect(x: width * 0.425, y: height * 0.05, width: width * 0.15, height: height * 0.15)
        path.addEllipse(in: rect3)
        
        return path
    }
}

#Preview {
    Weight()
        .fill(.orange, style: FillStyle(eoFill: true))
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
