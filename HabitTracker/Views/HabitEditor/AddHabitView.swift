//
//  HabitEditor.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//


import SwiftUI
import SwiftData

struct HabitEditor: View {
    // MARK: Data (Function) In
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var habit: Habit
    var isEditing: Bool = false
    
    // MARK: Action Function
    let onChoose: () -> Void

    // MARK: Data Owned by Me
    @State private var showInvalidHabitAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Habit Name", text: $habit.name)
                        .autocorrectionDisabled(false)
                        .scrollDismissesKeyboard(.interactively)
                }
                
                Section("Daily Goal") {
                    TextField("Enter the daily goal", value: $habit.dailyGoal, format: .number)
                        .keyboardType(.numberPad)
                        .scrollDismissesKeyboard(.interactively)
                }
                
                Section("Icon") {
                    IconChooser(selectedIcon: $habit.icon)
                }
                
                Section("Color") {
                    ColorChooser(selectedColor: $habit.color)
                }
            }
            .navigationTitle("Habit Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !isEditing {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem {
                        Button("Add") {
                            done()
                        }
                        .alert("Invalid Habit", isPresented: $showInvalidHabitAlert) {
                            Button("OK") {
                                showInvalidHabitAlert = false
                            }
                        } message: {
                            Text("A habit must have a name and a daily goal greater than zero.")
                        }
                    }
                }
            }
        }
    }
    
    func done() {
        if habit.isValid {
            onChoose()
            dismiss()
        } else {
            showInvalidHabitAlert = true
        }
    }
}

extension Habit {
    var isValid: Bool {
        !name.isEmpty && dailyGoal > 0
    }
}

#Preview {
    @Previewable var habit: Habit = Habit(sortOrder: 0, name: "Water", icon: "waterbottle", color: "blue", dailyGoal: 2500)
    HabitEditor(habit: habit) {
        print("game name changed to \(habit.name)")
        print("game pegs changed to \(habit.icon)")
        print("game name changed to \(habit.color)")
        print("game pegs changed to \(habit.dailyGoal)")
    }
}
