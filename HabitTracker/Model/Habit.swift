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
    var completions: [Log] = []
    var createdDate: Date = Date()
    var dailyGoal: Double = 1
    
    init() { } // For Codable extension + all vars need to be initialised
    
    init(sortOrder: Int, name: String, icon: String, color: String, completions: [Log] = [], createdDate: Date = Date(), dailyGoal: Double = 1.0) {
        self.sortOrder = sortOrder
        self.name = name
        self.icon = icon
        self.color = color
        self.completions = completions
        self.createdDate = createdDate
        self.dailyGoal = dailyGoal
    }
    
    var isDefault: Bool { name == "Water" || name == "Calories" || name == "Weight"}
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
    
    func isCompletedOn(_ date: Date = Date()) -> Bool {
//        completions.contains { Calendar.current.isDateInToday($0.time) }
        totalOn(date) >= dailyGoal
    }
    
    func totalOn(_ date: Date = Date()) -> Double {
        var total: Double = 0.0
        let calender = Calendar.current
        
        for completion in completions {
            if calender.isDate(completion.time, inSameDayAs: date) {
                total += completion.amount
            }
        }
        
        return total
    }
    
    func addCompletion(_ date: Date, of amount: Double = 1.0) {
        if isCompletedOn(date), dailyGoal == 1.0 {
            completions.removeAll { Calendar.current.isDate($0.time, inSameDayAs: date) }
            print("Removed all completions for today")
        } else {
            completions.append(Log(time: date, amount: amount))
            print("Added completion on \(date) of \(amount)")
        }
    }
    
    func currentStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        let sortedCompletions = completions.sorted(by: { $0.time > $1.time })
        
        for completion in sortedCompletions {
            let completionDay = calendar.startOfDay(for: completion.time)
            if calendar.isDate(completionDay, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    func longestStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var maxStreak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        let sortedCompletions = completions.sorted(by: { $0.time > $1.time })
        
        for completion in sortedCompletions {
            let completionDay = calendar.startOfDay(for: completion.time)
            if calendar.isDate(completionDay, inSameDayAs: currentDate) {
                streak += 1
            } else {
                if streak > maxStreak { maxStreak = streak }
                streak = 1
                currentDate = completionDay
            }
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        if maxStreak == 0 { maxStreak = streak }
        
        return maxStreak
    }
}
