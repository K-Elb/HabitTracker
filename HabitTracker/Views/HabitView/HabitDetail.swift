//
//  HabitDetail.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitDetail: View {
    var habit: Habit
    var isDetailed: Bool = true
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HabitRow(habit: habit, isDetailed: isDetailed)
                
                if isDetailed {
                    YearView(habit: habit)
                    
                    if habit.dailyGoal != 1 || habit.name == "Weight" {
                        HistoryChart(habit: habit)
                    }
                    
                    Stats(habit: habit)
                    
                    //                EditButtons(habit: habit)
                }
            }
        }
        .background(Color.from(string: habit.color))
//        .ignoresSafeArea(edges: .top)
    }
}

struct EditButtons: View {
    var habit: Habit
    
    @State private var isAdding: Bool = false
    @State private var isEditingEntries: Bool = false
    @State private var isEditingHabit: Bool = false

    var body: some View {
        HStack {
            Button("Edit habit", systemImage: "pencil") {
                isEditingHabit = true
            }
            .sheet(isPresented: $isEditingHabit) {
                HabitEditor(habit: habit, isEditing: true) { }
            }
        }
        .buttonStyle(.bordered)
        
        HStack {
            Button(action: { isAdding = true }) {
                Label("Add missing entries", systemImage: "plus")
            }
            .sheet(isPresented: $isAdding) {
                AddEntries(habit: habit)
            }
            
            Button(action: {isEditingEntries = true }) {
                Label("Edit entries", systemImage: "pencil")
            }
            .sheet(isPresented: $isEditingEntries) {
                EditEntries(habit: habit)
            }
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    NavigationStack {
        HabitDetail(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "cyan", dailyGoal: 5.0))
    }
}
