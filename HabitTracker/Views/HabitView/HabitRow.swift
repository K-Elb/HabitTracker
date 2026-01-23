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
            HStack {
                Image(systemName: habit.icon)
                    .font(.title.bold())
                    .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
                    .foregroundStyle(.wb)
                    .padding(.leading, 8)
                
                Spacer()
                
                if habit.isDefault {
                    let amount = habit.name == "Weight" ? String(habit.totalOn(selectedDate)) : String(Int(habit.totalOn(selectedDate)))
                    Text("\(amount) \(habit.unit)")
                        .font(.title.bold())
                        .foregroundStyle(.wb)
                }
                
                addButton
            }
            .frame(maxHeight: 56)
            .padding(.top, 64)
            
            title
            
            if isDetailed {
                Stats(habit: habit)
                
                WeekView(habit: habit, selectedDate: $selectedDate)
            }
        }
        .padding([.horizontal, .bottom], isDetailed ? 24 : 8)
        .background(Color.from(string: habit.color), in: .rect(cornerRadius: isDetailed ? 0 : 32))
        .containerShape(.rect(cornerRadius: 32))
//        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal, isDetailed ? 0 : 16)
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            Text(habit.name)
                .font(.title)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            Spacer()
            
            if habit.dailyGoal != 1 {
                Label("\(Int(habit.dailyGoal))", systemImage: "target")
                    .font(.caption)
            }
        }
        .foregroundStyle(Color.from(string: habit.color))
        .frame(maxWidth: .infinity, alignment: .leading)
        .bold()
        .padding(12)
        .frame(height: 136)
        .background(.wb, in: .rect(cornerRadius: 24))
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
    HabitRow(habit: Habit(sortOrder: 0, name: "Water", icon: "book.fill", color: "orange"),isDetailed: false, selectedDate: $selectedDate)
}
