//
//  HabitDetail.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitDetail: View {
    @Environment(\.dismiss) var dismiss

    var habit: Habit
    var isDetailed: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HabitRow(habit: habit, isDetailed: isDetailed)
                    
                    if isDetailed {
                        YearView(habit: habit)
                        
                        if habit.dailyGoal != 1 || habit.name == "Weight" {
                            HistoryChart(habit: habit)
                        }
                        
                        Stats(habit: habit)
                    }
                }
            }
            .background(Color.from(string: habit.color))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {dismiss()}) {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem {
                    EditButtons(habit: habit)
                }
            }
        }
    }
}

struct EditButtons: View {
    var habit: Habit
    
    @State private var isAdding: Bool = false
    @State private var isEditingEntries: Bool = false
    @State private var isEditingHabit: Bool = false

    var body: some View {
        Menu {
            Button("Edit habit", systemImage: "pencil") {
                isEditingHabit = true
            }
            Button("Add missing entries", systemImage: "plus") {
                isAdding = true
            }
            Button("Edit entries", systemImage: "pencil") {
                isEditingEntries = true
            }
        } label: {
            Image(systemName: "ellipsis")
        }
        .sheet(isPresented: $isEditingHabit) {
            HabitEditor(habit: habit, isEditing: true) { }
        }
        .sheet(isPresented: $isAdding) {
            AddEntries(habit: habit)
        }
        .sheet(isPresented: $isEditingEntries) {
            EditEntries(habit: habit)
        }
    }
}

#Preview {
    NavigationStack {
        HabitDetail(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "cyan", dailyGoal: 5.0))
    }
}
