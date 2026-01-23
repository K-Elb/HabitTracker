//
//  Stats.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 20/01/2026.
//

import SwiftUI

struct Stats: View {
    var habit: Habit
    
    @State private var week: Double = 0
    @State private var month: Double = 0
    @State private var year: Double = 0
    @State private var total: Double = 0
    @State private var currentStreak: Int = 0
    @State private var longestStreak: Int = 0
    
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
        .onAppear {
            calculateStats()
        }
    }
    
    func calculateStats() {
        let calendar = Calendar.current
        let today = Date()
        let thisWeek = calendar.dateInterval(of: .weekOfYear, for: today)!
        let thisMonth = calendar.dateInterval(of: .month, for: today)!
        let thisYear = calendar.dateInterval(of: .year, for: today)!
        
        var daysInWeek: [Double] = []
        var daysInMonth: [Double] = []
        var daysInYear: [Double] = []
        
        for completion in habit.completions {
            if thisWeek.contains(completion.time) {
                daysInWeek.append(completion.amount)
                daysInMonth.append(completion.amount)
                daysInYear.append(completion.amount)
            } else if thisMonth.contains(completion.time) {
                daysInMonth.append(completion.amount)
                daysInYear.append(completion.amount)
            } else if thisYear.contains(completion.time) {
                daysInYear.append(completion.amount)
            }
        }
        
        if habit.name == "Weight" {
            week = daysInWeek.reduce(0, +)/Double(daysInWeek.count)
            month = daysInMonth.reduce(0, +)/Double(daysInMonth.count)
            year = daysInYear.reduce(0, +)/Double(daysInYear.count)
        } else {
            week = daysInWeek.reduce(0, +)
            month = daysInMonth.reduce(0, +)
            year = daysInYear.reduce(0, +)
        }
        
        total = totalAmount()
        
        currentStreak = habit.currentStreak()
        
        longestStreak = habit.longestStreak()
    }
    
    func totalAmount() -> Double {
        var total = 0.0
        for completion in habit.completions {
            total += completion.amount
        }
        if habit.name == "Weight" {
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
