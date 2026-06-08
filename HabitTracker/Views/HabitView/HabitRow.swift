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
    var stacked: Bool = false
    
    @State private var selectedDate: Date = Date()
    @State private var isShowingSheet: Bool = false
    @State private var isTapped: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: habit.icon)
                    .padding(8)
                    .foregroundStyle(.wb)
                
                Spacer()
                
                if habit.type != "once" {
                    Text("\(habit.isAmountInt ? String(Int(habit.totalOn(selectedDate))) : String(habit.totalOn(selectedDate))) \(habit.unit)")
                        .foregroundStyle(.wb)
                }
                
                addButton
            }
            .frame(height: 48)
            .font(.title.bold())
            .padding(.top)
            
            title
            
            if !stacked {
                WeekView(habit: habit, selectedDate: $selectedDate)
                    .transition(.asymmetric(insertion: .offset(y: 800), removal: .push(from: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: isDetailed ? 0 : 24))
        .padding(.bottom, 8)
        .padding(.horizontal, isDetailed ? 16 : 8)
        .background(Color.from(string: habit.color), in: .rect(cornerRadius: isDetailed ? 0 : 32))
        .padding(.horizontal, isDetailed ? 0 : 8)
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            Text(habit.name)
                .font(.title.bold())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            Spacer()
            
            if habit.dailyGoal != 1 {
                Label("\(Int(habit.dailyGoal))", systemImage: "target")
                    .font(.caption.bold())
            }
        }
        .foregroundStyle(Color.from(string: habit.color))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .frame(height: 136)
        .background(.wb, in: .rect(cornerRadius: 24))
    }
    
    var addButton: some View {
        Button(action: { addHabitEntry() }) {
            Image(systemName: habit.isCompleted(selectedDate) ? "checkmark" : "plus")
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 8)
        .font(.title.bold())
        .foregroundStyle(.wb)
        .contentTransition(.symbolEffect(.replace))
        .sheet(isPresented: $isShowingSheet) {
            AddEntry(habit: habit, selectedDate: selectedDate)
        }
        .sensoryFeedback(.impact, trigger: isTapped)
        .onAppear {
            selectedDate = Date()
        }
    }
    
    func addHabitEntry() {
        if habit.type == "once" {
            isTapped.toggle()
            habit.addCompletion(selectedDate)
        } else if habit.type == "onceWithValue" && habit.entriesOn(selectedDate) > 0 {
            isTapped.toggle()
            habit.addCompletion(selectedDate)
        } else {
            isShowingSheet = true
        }
    }
}

#Preview {
    HabitRow(habit: Habit(sortOrder: 0, name: "Weight", icon: "book.fill", color: "orange"), isDetailed: false)
}
