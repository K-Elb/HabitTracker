//
//  UIExtensions.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import SwiftUI

extension Color {
    static func from(string: String) -> Color {
        switch string {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        case "indigo": return .indigo
        case "teal": return .teal
        case "mint": return .mint
        case "cyan": return .cyan
        default: return fromHex(string)
        }
    }
    
    static func fromHex(_ hex: String) -> Color {
        let components = hex
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        guard components.count == 3 else { return .blue }
        
        return Color(
            red: components[0] / 255,
            green: components[1] / 255,
            blue: components[2] / 255
        )
    }
}
