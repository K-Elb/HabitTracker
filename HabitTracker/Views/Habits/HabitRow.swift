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
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: habit.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.wb)
                    .padding(8)
                
                Spacer()
                
                Button(action: { habit.toggleCompletion() }) {
                    Circle()
                        .foregroundStyle(habit.isCompletedToday() ? .clear : .wb)
                        .frame(width: 48)
                        .overlay {
                            Image(systemName: habit.isCompletedToday() ? "checkmark" : "plus")
                                .font(.title2.bold())
                                .foregroundStyle(habit.isCompletedToday() ? .wb : Color.from(string: habit.color))
                                .contentTransition(.symbolEffect(.replace))
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.title)
                    
                    Spacer()
                    
                    HStack {
                        Label("\(habit.completions.count)", systemImage: "sum")
                            .font(.caption)
                        
                        Label("\(habit.currentStreak())", systemImage: "flame")
                            .font(.caption)
                        
                        Spacer()
                        
                        Text("\(habit.createdDate, style: .date)")
                            .font(.caption)
                    }
                }
                .foregroundStyle(.wb)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            }
            .bold()
            .padding(8)
            .frame(height: 120)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

#Preview {
    HabitRow(habit: Habit(name: "Reading", icon: "book.fill", color: "orange"))
}
