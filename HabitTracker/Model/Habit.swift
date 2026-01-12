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
    var name: String
    var icon: String
    var color: String
    var completions: [Log]
    var createdDate: Date
    
    init(name: String, icon: String, color: String) {
        self.name = name
        self.icon = icon
        self.color = color
        self.completions = []
        self.createdDate = Date()
    }
    
    var isDefault: Bool { name == "Water" || name == "Calories" || name == "Weight"}
    
    func isCompletedToday() -> Bool {
        completions.contains { Calendar.current.isDateInToday($0.time) }
    }
    
    func toggleCompletion() {
        if isCompletedToday() {
            completions.removeAll { Calendar.current.isDateInToday($0.time) }
        } else {
            completions.append(Log(time: Date(), amount: 1))
        }
    }
    
    func add(_ amount: Double) {
        completions.append(Log(time: Date(), amount: amount))
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
