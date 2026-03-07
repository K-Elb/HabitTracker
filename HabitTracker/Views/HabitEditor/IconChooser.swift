//
//  IconChooser.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import SwiftUI

struct IconChooser: View {
    @Binding var selectedIcon: String
    
    let icons: [String] = ["figure.walk.suitcase.rolling", "globe", "star.fill", "heart.fill", "flag.fill", "flag.pattern.checkered.2.crossed", "bookmark.fill", "target", "trophy.fill", "sparkles", "bolt.fill", "clock.fill", "calendar", "timer", "hourglass.bottomhalf.fill", "app.background.dotted", "stopwatch.fill", "sunrise.fill", "sunset.fill", "figure.walk", "figure.run", "figure.yoga", "figure.mind.and.body", "lungs.fill", "drop.fill", "pills.fill", "bed.double.fill", "brain.head.profile.fill", "dumbbell.fill", "flame.fill", "bicycle", "sportscourt.fill", "figure.strengthtraining.traditional", "figure.cooldown", "figure.outdoor.cycle", "figure.hiking", "figure", "person.3.fill", "apple.meditate", "fork.knife", "leaf.fill", "carrot.fill", "cup.and.saucer.fill", "waterbottle.fill", "takeoutbag.and.cup.and.straw.fill", "fish.fill", "dog.fill", "cat.fill", "mug.fill", "cart.fill", "moon.fill", "cloud.sun.fill", "headphones.over.ear", "face.dashed.fill", "wind", "waveform.path.ecg", "brain.fill", "ear.fill", "eye.fill", "nose.fill", "book.fill", "book.closed.fill", "books.vertical.fill", "pencil", "list.bullet", "suitcase.rolling.and.suitcase.fill", "chart.bar.fill", "chart.line.uptrend.xyaxis", "graduationcap.fill", "keyboard.fill", "lightbulb.fill", "house.fill", "briefcase.fill", "bag.fill", "phone.fill", "lock.fill", "key.fill", "car.fill", "bus.fill", "airplane", "globe.americas.fill"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 16) {
            ForEach(icons, id: \.self) { icon in
                button(icon)
            }
        }
    }
    
    func button(_ icon: String) -> some View {
        Button(action: { selectedIcon = icon }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedIcon == icon ? .gray.opacity(0.5) : .clear)
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
    @Previewable @State var icon: String = "figure.walk.suitcase.rolling"
    IconChooser(selectedIcon: $icon)
        .onChange(of: icon) {
            print("icon = \(icon)")
        }
}
