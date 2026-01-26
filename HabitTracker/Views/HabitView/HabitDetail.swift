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
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HabitRow(habit: habit, isDetailed: isDetailed)

            if isDetailed {
                YearView(habit: habit)
                
                EditButtons(habit: habit)
            }
        }
        .ignoresSafeArea(edges: .top)
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
            
            Button("Save Habit", systemImage: "square.and.arrow.down") {
                if let json = try? JSONEncoder().encode(habit) {
                    let url = URL.documentsDirectory.appendingPathComponent(habit.name).appendingPathExtension("json")
                    try? json.write(to: url)
                }
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
        HabitDetail(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "cyan"))
    }
}
