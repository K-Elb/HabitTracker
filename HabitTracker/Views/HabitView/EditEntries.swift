//
//  EditEntries.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import SwiftUI

struct EditEntries: View {
    var habit: Habit
    
    var body: some View {
        if habit.completions.isEmpty {
            ContentUnavailableView("No Entries", systemImage: "xmark")
        } else {
            NavigationView {
                List {
                    ForEach(habit.completions) { entry in
                        VStack(alignment: .leading) {
                            if habit.isDefault {
                                let amount = habit.name == "Weight" ? String(entry.amount) : String(Int(entry.amount))
                                Text("\(amount) \(habit.unit)")
                                    .bold()
                            }
                            HStack {
                                Text(entry.time, style: .date)
                                Spacer()
                                Text(entry.time, style: .time)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Entries")
            }
            .onAppear {
                habit.completions = habit.completions.sorted(by: { $0.time > $1.time })
            }
        }
    }
    
    func delete(offsets: IndexSet) {
        for offset in offsets {
            habit.completions.remove(at: offset)
        }
        habit.completions = habit.completions.sorted(by: { $0.time > $1.time })
    }
    
//    func addEntries() {
//        var date = Date()
//        for i in 0..<10 {
//            habit.completions.append(Log(time: date, amount: Double.random(in: 0...3)))
//            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
//        }
//    }
}

#Preview {
    @Previewable @State var habit = Habit(sortOrder: 0, name: "rf", icon: "waterbottle", color: "cyan")
    EditEntries(habit: habit)
}
