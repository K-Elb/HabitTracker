//
//  Habit.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable {
    var id: UUID
    var name: String
    var icon: String
    var color: String
    var frequency: Frequency
    var completions: [Date]
    var createdDate: Date
    
    enum Frequency: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        
        var icon: String {
            switch self {
            case .daily: return "sun.max.fill"
            case .weekly: return "calendar"
            }
        }
    }
    
    init(id: UUID = UUID(), name: String, icon: String, color: String, frequency: Frequency) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.frequency = frequency
        self.completions = []
        self.createdDate = Date()
    }
    
    func isCompletedToday() -> Bool {
        completions.contains { Calendar.current.isDateInToday($0) }
    }
    
    func toggleCompletion() {
        if isCompletedToday() {
            completions.removeAll { Calendar.current.isDateInToday($0) }
        } else {
            completions.append(Date())
        }
    }
    
    func currentStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        let sortedCompletions = completions.sorted(by: >)
        
        for completion in sortedCompletions {
            let completionDay = calendar.startOfDay(for: completion)
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
