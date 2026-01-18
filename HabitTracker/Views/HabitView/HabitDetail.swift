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
    @State private var year: Int = 2026
    @State private var isEditingHabit: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HabitRow(habit: habit, isDetailed: isDetailed, selectedDate: $selectedDate)
                
                if isDetailed {
                    YearView(habit: habit, year: $year)
                }
            }
        }
        .toolbar {
            if isDetailed {
                editHabit

                EditButtons(habit: habit)
            }
        }
    }
    
    var editHabit: some View {
        Button("Edit habit", systemImage: "pencil") {
            isEditingHabit = true
        }
        .sheet(isPresented: $isEditingHabit) {
            HabitEditor(habit: habit, isEditing: true) { }
        }
    }
}

struct EditButtons: View {
    var habit: Habit
    
    @State private var isAdding: Bool = false
    @State private var isEditingEntries: Bool = false
    
    var body: some View {
        Menu {
            Button(action: { isAdding = true }) {
                Label("Add missing entries", systemImage: "plus")
            }
            
            Button(action: {isEditingEntries = true }) {
                Label("Edit entries", systemImage: "pencil")
            }
        
            Button("Save", systemImage: "square.and.arrow.down") {
                if let json = try? JSONEncoder().encode(habit) {
                    let url = URL.documentsDirectory.appendingPathComponent(habit.name).appendingPathExtension("json")
                    try? json.write(to: url)
                }
            }
        } label: {
            Image(systemName: "ellipsis")
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
        HabitDetail(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "cyan"))
    }
}
