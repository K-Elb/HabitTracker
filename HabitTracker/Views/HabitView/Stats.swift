//
//  Stats.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 20/01/2026.
//

import SwiftUI

struct Stats: View {
    let habit: Habit
    
    let calendar = Calendar.current
    let today = Date()
    
    var week: Double  { totalAmount(for: .weekOfYear) }
    var month: Double { totalAmount(for: .month) }
    var year: Double  { totalAmount(for: .year) }
    var total: Double { totalOverall() }
    var currentStreak: Int { habit.currentStreak() }
    var longestStreak: Int { habit.longestStreak() }
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text("Stats")
//                .font(.title.bold())
//                .foregroundStyle(.wb)
//                .padding(.top)
//                .padding(.leading, 8)
            HStack {
                stat("Week", value: week)
                stat("Month", value: month)
            }
            HStack {
                stat("Year", value: year)
                stat("Total", value: total)
            }
            HStack {
                stat("Current Streak", value: Double(currentStreak))
                stat("Longest Streak", value: Double(longestStreak))
            }
            Text("Started on \(habit.createdDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption.bold())
                .foregroundStyle(.wb.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
//                .background(.wb.opacity(0.25), in: .capsule)
        }
        .padding()
    }
    
    func totalAmount(for component: Calendar.Component) -> Double {
        guard let interval = calendar.dateInterval(of: component, for: today) else {
            return 0
        }
        return totalAmount(in: interval)
    }

    func totalAmount(in interval: DateInterval) -> Double {
        let amounts = habit.logs
            .filter { interval.contains($0.time) }
            .map { $0.amount }

        guard !amounts.isEmpty else { return 0 }

        if habit.name == "Weight" {
            return amounts.reduce(0, +) / Double(amounts.count)
        }

        return amounts.reduce(0, +)
    }
    
//    func totalOverall() -> Double {
//        var total = 0.0
//        for completion in habit.logs {
//            total += completion.amount
//        }
//        if habit.name == "Weight" {
//            if habit.logs.count == 0 {
//                return 0
//            }
//            return total/Double(habit.logs.count)
//        }
//        return total
//    }
    
    func totalOverall() -> Double {
        let amounts = habit.logs.map { $0.amount }
        
        guard !amounts.isEmpty else { return 0 }
        
        if habit.name == "Weight" {
            return amounts.reduce(0, +) / Double(amounts.count)
        }

        return amounts.reduce(0, +)
    }
    
    func stat(_ title: String, value: Double) -> some View {
        VStack(alignment: .leading) {
            Text(habit.name == "Weight" && !title.contains("Streak") ? value.formatted(.number.precision(.fractionLength(1))).description : Int(value).description)
                .font(.title.bold())
                .padding(.bottom)
            Text(title)
                .font(.caption.bold())
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color.from(string: habit.color))
        .background(.wb, in: .rect(cornerRadius: 24))
    }
}

#Preview {
    Stats(habit: Habit(sortOrder: 0, name: "Weight", icon: "book.fill", color: "orange"))
        .background(.orange)
}
