//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//


import SwiftUI
import SwiftData

struct HabitRow: View {
    let habit: Habit
    var isDetailed: Bool = false
    @Binding var selectedDate: Date

    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: habit.icon)
                    .font(.title.bold())
                    .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
                    .foregroundStyle(.wb)
                    .padding(.leading, 8)
                
                if habit.isDefault {
                    let amount = habit.name == "Weight" ? String(habit.totalOn(selectedDate)) : String(Int(habit.totalOn(selectedDate)))
                    Text("\(amount) \(habit.unit)")
                        .font(.title.bold())
                        .foregroundStyle(.wb)
                        .padding(8)
                }
                
                Spacer()
                
                addButton
            }
            .frame(height: 56)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    HStack {
                        Label("\(habit.completions.count)", systemImage: "rectangle.stack.fill")
                        Label("\(habit.currentStreak())", systemImage: "flame.fill")
                        if habit.dailyGoal != 1 {
                            Label("\(Int(habit.dailyGoal))", systemImage: "target")
                        }
                    }
                    .font(.caption)
                }
                .foregroundStyle(Color.from(string: habit.color))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .bold()
            .padding(12)
            .frame(height: 136)
            .background(.wb)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            if isDetailed {
                Stats(habit: habit)
                
                WeekView(habit: habit, selectedDate: $selectedDate)
            }
        }
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 32))
//        .padding(.horizontal)
    }
    
    var addButton: some View {
        Button(action: { addHabitEntry() }) {
            let isDone = habit.isCompletedOn(selectedDate)
            Image(systemName: isDone ? "checkmark" : "plus")
                .font(.title.bold())
                .foregroundStyle(.wb)
                .padding(8)
//                .foregroundStyle(isDone ? .wb : Color.from(string: habit.color))
//                .background(isDone ? .clear : .wb)
//                .clipShape(RoundedRectangle(cornerRadius: 16))
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingSheet) {
            switch habit.name {
            case "Water", "Calories", "Weight": AddEntry(habit: habit, selectedDate: selectedDate)
            default: EmptyView()
            }
        }
    }
    
    func addHabitEntry() {
        switch habit.name {
        case "Water", "Calories", "Weight": isShowingSheet = true
        default: habit.addCompletion(selectedDate)
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    HabitRow(habit: Habit(sortOrder: 0, name: "Water", icon: "book.fill", color: "orange"), selectedDate: $selectedDate)
}
