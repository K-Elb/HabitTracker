//
//  AddEntries.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//


import SwiftUI
import SwiftData

struct AddEntries: View {
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
            VStack {
                MultiDatePicker("Date", selection: $selectedDates, in: bounds)
//                .frame(height: 300)
                .onChange(of: selectedDates) { oldSelection, newSelection in
                    syncLogs(with: newSelection)
                }
                
//                List {
//                    ForEach(habit.logs) { log in
//                        HStack {
//                            Text(log.time, style: .date)
//                            Spacer()
//                            TextField("Value", value: binding(for: log), format: .number)
//                                .keyboardType(.decimalPad)
//                                .frame(maxWidth: 80, alignment: .trailing)
//                        }
//                    }
//                }
            }
//            .padding()
            .onAppear {
                selectedDates = getDates()
            }
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        save()
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
        }
    }
    
    func date(from components: DateComponents) -> Date {
        calendar.date(from: components)!
    }
    
    func getDates() -> Set<DateComponents> {
        Set(habit.logs.map { calendar.dateComponents([.year, .month, .day], from: $0.time) })
    }
    
    func syncLogs(with selection: Set<DateComponents>) {
        let dates = selection.map { date(from: $0) }
        
        // Add
        for date in dates {
            if !habit.logs.contains(where: { calendar.isDate($0.time, inSameDayAs: date) }) {
                habit.addCompletion(date)
                print("Added new entry")
            }
        }
        
        // Remove
        habit.logs.removeAll { log in
            !dates.contains { calendar.isDate($0, inSameDayAs: log.time) }
        }
    }
    
    func binding(for log: Log) -> Binding<Double> {
        Binding(
            get: { log.value },
            set: { newValue in
                if let index = habit.logs.firstIndex(of: log) {
                    habit.logs[index].value = newValue
                }
            }
        )
    }
    
    func save() {
        for date in selectedDates.compactMap(\.date) {
            if !habit.logs.contains(where: { calendar.isDate($0.time, inSameDayAs: date) }) {
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
    AddEntries(habit: Habit(sortOrder: 0, name: "drink water", icon: "drop.fill", color: "cyan"))
}
