//
//  Stats.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 20/01/2026.
//

import SwiftUI

struct Stats: View {
    var habit: Habit
    
    let calendar = Calendar.current
    let today = Date()
    var week: Double {
        let week = calendar.dateInterval(of: .weekOfYear, for: today)!
        return totalAmount(this: week)
    }
    var month: Double {
        let month = calendar.dateInterval(of: .month, for: today)!
        return totalAmount(this: month)
    }
    var year: Double {
        let year = calendar.dateInterval(of: .month, for: today)!
        return totalAmount(this: year)
    }
    var total: Double {
        return totalOverall()
    }
    var currentStreak: Int {
        habit.currentStreak()
    }
    var longestStreak: Int {
        habit.longestStreak()
    }
    
    var body: some View {
        VStack {
            HStack {
                stat("Week", value: week)
                stat("Month", value: month)
                stat("Year", value: year)
            }
            HStack {
                stat("Current Streak", value: Double(currentStreak))
                stat("Longest Streak", value: Double(longestStreak))
                stat("Total", value: total)
            }
        }
    }
    
    func totalAmount(this dates: DateInterval) -> Double {
        var items: [Double] = []
        for completion in habit.completions {
            if dates.contains(completion.time) {
                items.append(completion.amount)
            }
        }
        if habit.name == "Weight" {
            if items.count == 0 {
                return 0
            }
            return items.reduce(0, +)/Double(items.count)
        }
        return items.reduce(0, +)
    }
    
    func totalOverall() -> Double {
        var total = 0.0
        for completion in habit.completions {
            total += completion.amount
        }
        if habit.name == "Weight" {
            if habit.completions.count == 0 {
                return 0
            }
            return total/Double(habit.completions.count)
        }
        return total
    }
    
    func stat(_ title: String, value: Double) -> some View {
        VStack(alignment: .leading) {
            Text(habit.name == "Weight" && !title.contains("Streak") ? value.formatted(.number.precision(.fractionLength(1))).description : Int(value).description)
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
        .background(.wb, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    Stats(habit: Habit(sortOrder: 0, name: "Weight", icon: "book.fill", color: "orange"))
        .background(.ultraThinMaterial)
}
