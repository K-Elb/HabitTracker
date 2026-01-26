//
//  Habit.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import Foundation
import SwiftData

@Model
final class Log {
    var time: Date = Date()
    var amount: Double = 0
    var habit: Habit? // For Habit to add completions normally
    
    init() { } // For Codable extension + all vars need to be initialised
    
    init(time: Date, amount: Double) {
        self.time = time
        self.amount = amount
    }
}

@Model
final class Habit {
    var sortOrder: Int = 0
    @Attribute(.unique) var name: String = ""
    var icon: String = ""
    var color: String = ""
    var logs: [Log] = []
    var createdDate: Date = Date()
    var dailyGoal: Double = 1
    
    init() { } // For Codable extension + all vars need to be initialised
    
    init(sortOrder: Int, name: String, icon: String, color: String, logs: [Log] = [], createdDate: Date = Date(), dailyGoal: Double = 1.0) {
        self.sortOrder = sortOrder
        self.name = name
        self.icon = icon
        self.color = color
        self.logs = logs
        self.createdDate = createdDate
        self.dailyGoal = dailyGoal
    }
    
    var isDefault: Bool {
        name == "Water" || name == "Calories" || name == "Weight"
    }
    
    var unit: String {
        switch name {
        case "Water": return "ml"
        case "Calories": return "kcal"
        case "Weight": return "kg"
        default: return ""
        }
    }
    
    var isAmountInt: Bool {
        switch name {
        case "Water", "Calories": return true
        default: return false
        }
    }
    
    func totalOn(_ date: Date = Date()) -> Double {
        var total: Double = 0.0
        let calender = Calendar.current
        
        for completion in logs {
            if calender.isDate(completion.time, inSameDayAs: date) {
                total += completion.amount
            }
        }
        
        return total
    }
    
    func addCompletion(_ date: Date, of amount: Double = 1.0) {
        if totalOn(date) >= dailyGoal, dailyGoal == 1.0 {
            logs.removeAll { Calendar.current.isDate($0.time, inSameDayAs: date) }
            print("Removed all completions for today")
        } else {
            logs.append(Log(time: date, amount: amount))
            print("Added completion on \(date) of \(amount)")
        }
    }
    
    func currentStreak() -> Int {
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())
        var streak = 0
        
        let loggedDays = Set(logs.map { calendar.startOfDay(for: $0.time) })
        
        while true {
            if loggedDays.contains(currentDate), totalOn(currentDate) >= dailyGoal {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if calendar.isDateInToday(currentDate) {
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    func longestStreak() -> Int {
        let calendar = Calendar.current
        var maxStreak = 0
        var currentStreak = 0
        var previousDay: Date?
        
        let successfulDays = Set(logs.map { calendar.startOfDay(for: $0.time) }.filter { totalOn($0) >= dailyGoal })
        let sortedDays = successfulDays.sorted()
        
        for day in sortedDays {
            if let prev = previousDay, calendar.isDate(day, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: prev)!) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            
            maxStreak = max(maxStreak, currentStreak)
            previousDay = day
        }
        
        return maxStreak
    }
}
