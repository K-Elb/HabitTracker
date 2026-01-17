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
        
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HabitRow(habit: habit, isDetailed: isDetailed)
                
                if isDetailed {
                    YearView(habit: habit, year: $year)
                }
            }
        }
        .toolbar {
            if isDetailed {
                ToolbarItem {
                    EditButtons(habit: habit)
                }
            }
        }
    }
}

struct EditButtons: View {
    @Environment(\.modelContext) var modelContext
    var habit: Habit
    
    @State private var isAdding: Bool = false
    @State private var isEditingHabit: Bool = false
    
    var body: some View {
        Menu {
            Button(action: { isEditingHabit = true }) {
                Label("Edit Habit", systemImage: "pencil")
            }
            
            Button(action: { modelContext.delete(habit) }) {
                Label("Delete Habit", systemImage: "trash")
            }
            
            Divider()
            
            Button(action: { isAdding = true }) {
                Label("Add a missing entry", systemImage: "plus")
            }
            
            
            Button(action: {}) {
                Label("Delete/Edit", systemImage: "pencil")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
        .sheet(isPresented: $isAdding) {
            DateSelectorView(habit: habit)
        }
        .sheet(isPresented: $isEditingHabit) {
            AddHabitView(habitsCount: 0, habit: habit, isEditing: true)
        }
    }
}

struct DateSelectorView: View {
    @Environment(\.dismiss) var dismiss
    var habit: Habit
    
    @State private var selectedDates: Set<DateComponents> = []
    @State private var startDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    @State private var endDate = Date()
    
    let calendar = Calendar.current
    var bounds: Range<Date> {
        return startDate..<endDate
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                MultiDatePicker(
                    "Date",
                    selection: $selectedDates,
                    in: bounds
                )
                .frame(height: 300)
                
                Text("Selected date: \(selectedDates.count)")
            }
            .padding()
            .onAppear {
                selectedDates = getDates()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func getDates() -> Set<DateComponents> {
        Set(habit.completions.map { calendar.dateComponents([.year, .month, .day], from: $0.time) })
    }
    
    func save() {
        for date in selectedDates.compactMap(\.date) {
            if !habit.completions.contains(where: { calendar.isDate($0.time, inSameDayAs: date) }) {
                habit.addCompletion(date)
                print("added")
            }
        }
        
//        let dates = habit.completions.map { calendar.dateComponents([.year, .month, .day], from: $0.time) }
//        for date in dates {
//            if selectedDates.contains(where: { $0 == date }), let d = calendar.date(from: date) {
//                habit.completions.removeAll { calendar.isDate($0.time, inSameDayAs: d) }
//                print("deleted")
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        HabitDetail(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "mint"))
    }
}
