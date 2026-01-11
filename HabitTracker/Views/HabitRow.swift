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
    
    var body: some View {
        HStack {
            Circle()
                .fill(.wb)
                .frame(width: 48)
                .overlay {
                    Image(systemName: habit.icon)
                        .font(.title2)
                        .foregroundColor(Color.from(string: habit.color))
                }
            
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.title2)
                    .foregroundStyle(.wb)
                
                HStack {
                    Label("\(habit.completions.count)", systemImage: "flame.fill")
                        .font(.caption)
                    
                    Label("\(habit.currentStreak())", systemImage: "flame.fill")
                        .font(.caption)
                    
                    Label(habit.frequency.rawValue, systemImage: habit.frequency.icon)
                        .font(.caption)
                }
                .foregroundStyle(.thinMaterial)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
            
            Button(action: { habit.toggleCompletion() }) {
                Circle()
                    .fill(habit.isCompletedToday() ? .clear : .wb)
                    .frame(width: 48)
                    .overlay {
                        Image(systemName: habit.isCompletedToday() ? "checkmark" : "plus")
                            .font(.title2)
                            .foregroundColor(habit.isCompletedToday() ? .wb : Color.from(string: habit.color))
                            .contentTransition(.symbolEffect(.replace))
                    }
            }
            .buttonStyle(.plain)
        }
        .bold()
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(.capsule)
    }
}


#Preview {
    HabitRow(habit: Habit(name: "Reading", icon: "book", color: "orange", frequency: .daily))
        .padding()
}
