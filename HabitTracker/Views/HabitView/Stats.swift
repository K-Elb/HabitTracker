//
//  Stats.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 20/01/2026.
//

import SwiftUI

struct Stats: View {
    var habit: Habit
    
    var body: some View {
        VStack {
            HStack {
                stat("Week", value: 25)
                stat("Month", value: 7)
                stat("Year", value: 235)
            }
            HStack {
                stat("Current Streak", value: 235)
                stat("Longest Streak", value: 7)
                stat("Total", value: 25)
            }
        }
    }
    
    func stat(_ title: String, value: Int) -> some View {
        VStack(alignment: .leading) {
            Text(value.description)
                .font(.title.bold())
            Spacer()
            Text(title)
                .font(.caption.bold())
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        .foregroundStyle(Color.from(string: habit.color))
        .background(.wb)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    Stats(habit: Habit(sortOrder: 0, name: "Water", icon: "book.fill", color: "orange"))
        .background(.ultraThinMaterial)
}
