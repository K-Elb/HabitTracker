//
//  IconChooser.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import SwiftUI

struct IconChooser: View {
    @Binding var selectedIcon: String
    
    let icons: [String] = [
        "checkmark", "circle.fill", "star.fill", "heart.fill", "flag.fill",
        "bookmark.fill", "target", "trophy.fill", "sparkles", "bolt.fill",
        "clock.fill", "alarm.fill", "calendar", "timer", "hourglass.bottomhalf.fill",
        "repeat", "arrow.triangle.2.circlepath", "stopwatch.fill", "sunrise.fill", "sunset.fill",
        "figure.walk", "figure.run", "figure.yoga", "figure.mind.and.body", "heart.text.square.fill",
        "lungs.fill", "drop.fill", "pills.fill", "bed.double.fill", "brain.head.profile.fill",
        "dumbbell.fill", "flame.fill", "bicycle", "sportscourt.fill", "figure.strengthtraining.traditional",
        "figure.cooldown", "figure.outdoor.cycle", "figure.hiking", "figure", "apple.meditate",
        "fork.knife", "leaf.fill", "carrot.fill", "cup.and.saucer.fill", "waterbottle.fill",
        "takeoutbag.and.cup.and.straw.fill", "fish.fill", "apple.logo", "mug.fill", "cart.fill",
        "moon.fill", "cloud.sun.fill", "face.smiling.fill", "face.dashed.fill", "wind",
        "waveform.path.ecg", "brain.fill", "ear.fill", "eye.fill", "nose.fill",
        "book.fill", "book.closed.fill", "books.vertical.fill", "pencil", "list.bullet", "checklist",
        "chart.bar.fill", "chart.line.uptrend.xyaxis", "graduationcap.fill", "keyboard.fill", "lightbulb.fill",
        "house.fill", "briefcase.fill", "bag.fill", "phone.fill", "lock.fill",
        "key.fill", "car.fill", "bus.fill", "airplane", "globe.americas.fill"
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 36))]) {
            ForEach(icons, id: \.self) { icon in
                button(icon)
            }
        }
    }
    
    func button(_ icon: String) -> some View {
        Button(action: { selectedIcon = icon }) {
            Circle()
                .fill(selectedIcon == icon ? .gray.opacity(0.5) : Color.gray.opacity(0.1))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: icon)
                        .foregroundColor(selectedIcon == icon ? .accent : .gray)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var icon: String = "figure"
    IconChooser(selectedIcon: $icon)
        .onChange(of: icon) {
            print("icon = \(icon)")
        }
}
