//
//  Cup.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 23/01/2026.
//

import SwiftUI

struct CupParameters {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }

    static let segments = [
        Segment(
            line:    CGPoint(x: 0.20, y: 0.00),
            curve:   CGPoint(x: 0.10, y: 0.10),
            control: CGPoint(x: 0.09, y: 0.00)
        ),
        Segment(
            line:    CGPoint(x: 0.2, y: 0.9),
            curve:   CGPoint(x: 0.3, y: 1.0),
            control: CGPoint(x: 0.21, y: 1.0)
        ),
        Segment(
            line:    CGPoint(x: 0.70, y: 1.0),
            curve:   CGPoint(x: 0.80, y: 0.90),
            control: CGPoint(x: 0.79, y: 1.0)
        ),
        Segment(
            line:    CGPoint(x: 0.90, y: 0.1),
            curve:   CGPoint(x: 0.80, y: 0.0),
            control: CGPoint(x: 0.91, y: 0.00)
        )
    ]
}

struct Cup: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.8, y: height * 0.0))
        
        CupParameters.segments.forEach { segment in
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
        
        return path
    }
}

#Preview {
    Cup()
        .fill(.blue)
        .aspectRatio(1, contentMode: .fit)
}
