//
//  ColorChooser.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import SwiftUI

struct ColorChooser: View {
    @Binding var selectedColor: String

    @State private var shade: Double = 0
    @State private var originalColor: String = "255,56,60"

    var shadedRGB: (Int,Int,Int) {
        if let (r,g,b) = parseRGB(originalColor) {
            return shadeRGB(r: r, g: g, b: b, percentage: shade)
        }
        return (0,0,0)
    }
    
    let colors = ["255,56,60", "255,45,85", "241,74,0", "255,141,40", "255,204,0", "52,199,89", "0,200,179", "0,195,208", "0,192,232", "0,135,255", "97,85,245", "203,48,224", "142,142,147", "172,127,94"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
            ForEach(colors, id: \.self) { color in
                button(color)
            }
        }
        
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 80)
                .aspectRatio(3, contentMode: .fit)
                .foregroundStyle(Color(red: Double(shadedRGB.0) / 255, green: Double(shadedRGB.1) / 255, blue: Double(shadedRGB.2) / 255))
            
            VStack(alignment: .leading, spacing: 0) {
                Text("RGB: \(shadedRGB.0), \(shadedRGB.1), \(shadedRGB.2)")
                
                Slider(value: $shade, in: -0.2...0.2, step: 0.04)
                    .onChange(of: shade) {
                        selectedColor = rgbToString(shadedRGB)
                    }
                    .tint(Color(red: Double(shadedRGB.0) / 255, green: Double(shadedRGB.1) / 255, blue: Double(shadedRGB.2) / 255))
            }
        }
        .onAppear {
            originalColor = selectedColor
        }
    }
    
    func button(_ color: String) -> some View {
        Button(action: { selectedColor = color; shade = 0; originalColor = color }) {
            Circle()
                .fill(Color.from(string: color)) //originalColor == color ? Color.from(string: selectedColor) : Color.from(string: color)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if originalColor == color {
                        Image(systemName: "checkmark")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    func shadeRGB(r: Int, g: Int, b: Int, percentage: Double) -> (Int, Int, Int) {
        func adjust(_ value: Int) -> Int {
            let newValue: Double

            if percentage > 0 {
                // lighten
                newValue = Double(value) + (255 - Double(value)) * percentage
            } else {
                // darken
                newValue = Double(value) * (1 + percentage)
            }

            return max(0, min(255, Int(newValue)))
        }

        return (adjust(r), adjust(g), adjust(b))
    }
    
    func parseRGB(_ rgbString: String) -> (Int, Int, Int)? {
        let parts = rgbString.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        guard parts.count == 3 else { return nil }
        
        return (parts[0], parts[1], parts[2])
    }
    
    func rgbToString(_ rgb: (Int, Int, Int)) -> String {
        return "\(rgb.0),\(rgb.1),\(rgb.2)"
    }
}


#Preview {
    @Previewable @State var color: String = "241,74,0"
    ColorChooser(selectedColor: $color)
        .padding()
        .onChange(of: color) {
            print("color = \(color)")
        }
}
