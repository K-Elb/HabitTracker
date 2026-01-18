//
//  ColorChooser.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import SwiftUI

struct ColorChooser: View {
    @Binding var selectedColor: String
    
    let colors = ["blue", "green", "orange", "red", "purple", "yellow", "indigo", "teal",
                  "33,60,81", "101,148,177", "221,174,211", "238,238,238","254,234,201","255,205,201","253,172,172","253,121,121",
                  "0,247,255","176,255,250","255,0,135","255,125,176","54,47,79","91,35,255","0,139,255","228,255,48",
                  "42,0,78","80,0,115","198,35,0","241,74,0","255,101,0","30,62,98","11,25,44","0,34,77"
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 36))]) {
            ForEach(colors, id: \.self) { color in
                button(color)
            }
        }
    }
    
    func button(_ color: String) -> some View {
        Button(action: { selectedColor = color }) {
            Circle()
                .fill(Color.from(string: color))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if selectedColor == color {
                        Image(systemName: "checkmark")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var color: String = "figure"
    ColorChooser(selectedColor: $color)
        .onChange(of: color) {
            print("color = \(color)")
        }
}
