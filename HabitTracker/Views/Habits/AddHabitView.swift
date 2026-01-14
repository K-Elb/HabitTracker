//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//


import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var habit: Habit = Habit(name: "", icon: "checkmark", color: "blue", dailyGoal: 1)
    var isEditing: Bool = false
    
    @State private var c: Color = Color(red: 0, green: 0, blue: 0)
    
    let habitSymbols: [String] = [
        "checkmark", "circle.fill", "star.fill", "heart.fill", "flag.fill",
        "bookmark.fill", "target", "trophy.fill", "sparkles", "bolt.fill",
        "clock.fill", "alarm.fill", "calendar", "timer", "hourglass.bottomhalf.fill",
        "repeat", "arrow.triangle.2.circlepath", "stopwatch.fill", "sunrise.fill", "sunset.fill",
        "figure.walk", "figure.run", "figure.yoga", "figure.mind.and.body", "heart.text.square.fill",
        "lungs.fill", "drop.fill", "pills.fill", "bed.double.fill", "brain.head.profile.fill",
        "dumbbell.fill", "flame.fill", "bicycle", "sportscourt.fill", "figure.strengthtraining.traditional",
        "figure.cooldown", "figure.outdoor.cycle", "figure.hiking", "figure.stairs", "figure.flexibility",
        "fork.knife", "leaf.fill", "carrot.fill", "cup.and.saucer.fill", "waterbottle.fill",
        "takeoutbag.and.cup.and.straw.fill", "fish.fill", "apple.logo", "mug.fill", "cart.fill",
        "moon.fill", "cloud.sun.fill", "face.smiling.fill", "face.dashed.fill", "wind",
        "waveform.path.ecg", "brain.fill", "ear.fill", "eye.fill", "nose.fill",
        "book.fill", "books.vertical.fill", "pencil", "list.bullet", "checklist",
        "chart.bar.fill", "chart.line.uptrend.xyaxis", "graduationcap.fill", "keyboard.fill", "lightbulb.fill",
        "house.fill", "briefcase.fill", "bag.fill", "phone.fill", "lock.fill",
        "key.fill", "car.fill", "bus.fill", "airplane", "globe.americas.fill"
    ]
    
    let colors = ["blue", "green", "orange", "red", "purple", "yellow", "indigo", "teal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Habit Name", text: $habit.name)
                }
                
                Section("Daily Goal") {
                    TextField("Enter the daily goal", value: $habit.dailyGoal, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8)) {
                        ForEach(colors, id: \.self) { c in
                            Button(action: { habit.color = c }) {
                                Circle()
                                    .fill(Color.from(string: c))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        if habit.color == c {
                                            Image(systemName: "checkmark")
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
//                    ColorPicker("Choose color", selection: $c)
//                    Text("\(c.hashValue)")
//                        .foregroundStyle(c)
                }
                
                let color = Color.from(string: habit.color)
                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8)) {
                        ForEach(habitSymbols, id: \.self) { icon in
                            Button(action: { habit.icon = icon }) {
                                ZStack {
                                    Circle()
                                        .fill(habit.icon == icon ? color.opacity(0.2) : Color.gray.opacity(0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                    
                                    Image(systemName: icon)
                                        .foregroundColor(habit.icon == icon ? color : .gray)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button("Add") {
                        if !isEditing {
                            modelContext.insert(habit)
                        }
                        dismiss()
                    }
                    .bold()
                    .disabled(habit.name.isEmpty || habit.dailyGoal == 0)
                }
            }
        }
    }
}

#Preview {
    AddHabitView()
}





