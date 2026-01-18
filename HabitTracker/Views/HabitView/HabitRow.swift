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
        VStack(alignment: .leading) {
            HStack {
                if habit.isDefault {
                    let amount = habit.name == "Weight" ? String(habit.totalOn(selectedDate)) : String(Int(habit.totalOn(selectedDate)))
                    Label("\(amount) \(habit.unit)", systemImage: habit.icon)
                        .font(.title.bold())
                        .foregroundStyle(.wb)
                        .padding(8)
                } else {
                    Image(systemName: habit.icon)
                        .font(.title.bold())
                        .foregroundStyle(.wb)
                        .padding(8)
                }
                
                Spacer()
                
                addButton
            }
            .frame(height: 48)
            
            HStack(alignment: .top) {
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
                        
                        Spacer()
                    }
                }
                .foregroundStyle(Color.from(string: habit.color))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .bold()
            .padding(12)
            .frame(height: 136)
            .background(.wb)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            
            if isDetailed {
                WeekView(habit: habit, selectedDate: $selectedDate)
            }
        }
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal)
    }
    
    var addButton: some View {
        Button(action: { addHabitEntry() }) {
            Circle()
                .foregroundStyle(habit.isCompletedOn(selectedDate) ? .clear : .wb)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: habit.isCompletedOn(selectedDate) ? "checkmark" : "plus")
                        .font(.title2.bold())
                        .foregroundStyle(habit.isCompletedOn(selectedDate) ? .wb : Color.from(string: habit.color))
                        .contentTransition(.symbolEffect(.replace))
                }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingSheet) {
            switch habit.name {
            case "Water", "Calories", "Weight": DataPicker(habit: habit, selectedDate: selectedDate)
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
