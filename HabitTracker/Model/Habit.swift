//
//  Habit.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import Foundation
import SwiftData

@Model
class Log {
    var time: Date
    var amount: Double
    
    init(time: Date, amount: Double) {
        self.time = time
        self.amount = amount
    }
}

@Model
class Habit {
    @Attribute(.unique) var name: String
    var icon: String
    var color: String
    var completions: [Log]
    var createdDate: Date
    var dailyGoal: Double
    
    init(name: String, icon: String, color: String, dailyGoal: Double = 1.0) {
        self.name = name
        self.icon = icon
        self.color = color
        self.completions = []
        self.createdDate = Date()
        self.dailyGoal = dailyGoal
    }
    
    var isDefault: Bool { name == "Water" || name == "Calories" || name == "Weight"}
    
    func isCompletedOnThisDay(_ date: Date = Date()) -> Bool {
//        completions.contains { Calendar.current.isDateInToday($0.time) }
        totalOnThisDay(date) >= dailyGoal
    }
    
    func totalOnThisDay(_ date: Date = Date()) -> Double {
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
        if isCompletedOnThisDay(date), dailyGoal == 1.0 {
            completions.removeAll { Calendar.current.isDate($0.time, inSameDayAs: date) }
        } else {
            completions.append(Log(time: date, amount: amount))
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
            } else if completionDay < currentDate {
                break
            }
        }
        
        return streak
    }
}
