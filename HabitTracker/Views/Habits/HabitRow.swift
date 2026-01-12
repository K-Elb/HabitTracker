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
    var height: CGFloat = 60
    
    var body: some View {
        ZStack(alignment: .top) {
            if height < 80 {
                Rectangle()
                    .fill(Color.from(string: habit.color))
            } else {
                LinearGradient(colors: [Color.from(string: habit.color), Color.from(string: habit.color), .wb], startPoint: .top, endPoint: .bottom)
                    .frame(height: height)
            }
            
            VStack {
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
                            Label("Total: \(habit.completions.count)", systemImage: "flame.fill")
                                .font(.caption)
                            
                            Label("Streak: \(habit.currentStreak())", systemImage: "flame.fill")
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
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal)
    }
}


#Preview {
    HabitRow(habit: Habit(name: "Reading", icon: "book", color: "orange"), height: 120)
        .padding()
}
