//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//


import SwiftUI
import SwiftData

struct HabitRow: View {
    @Environment(\.modelContext) var modelContext
    let habit: Habit
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 48, height: 48)
                
                Image(systemName: habit.icon)
                    .font(.title2)
                    .foregroundColor(Color.from(string: habit.color))
            }
            
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.title2.bold())
                
//                HStack {
//                    Label("\(habit.currentStreak())", systemImage: "flame.fill")
//                        .font(.caption)
//                    
//                    Label(habit.frequency.rawValue, systemImage: habit.frequency.icon)
//                        .font(.caption)
//                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(action: { habit.toggleCompletion() }) {
                ZStack {
                    Circle()
                        .fill(habit.isCompletedToday() ? .clear : .white)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: habit.isCompletedToday() ? "checkmark" : "plus")
                        .font(.title2)
                        .foregroundColor(habit.isCompletedToday() ? .black : Color.from(string: habit.color))
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color.from(string: habit.color).opacity(0.5))
        .clipShape(.capsule)
        
    }
}


#Preview {
    HabitRow(habit: Habit(name: "Reading", icon: "book", color: "orange", frequency: .daily))
        .padding()
}
