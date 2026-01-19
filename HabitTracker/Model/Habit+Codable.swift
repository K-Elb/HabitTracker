//
//  Habit+Codable.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 18/01/2026.
//

import Foundation

extension Habit: Codable {
    enum CodingKeys: String, CodingKey {
        case sortOrder
        case name
        case icon
        case color
        case completions
        case createdDate
        case dailyGoal
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(
            sortOrder: try container.decode(Int.self, forKey: .sortOrder),
            name: try container.decode(String.self, forKey: .name),
            icon: try container.decode(String.self, forKey: .icon),
            color: try container.decode(String.self, forKey: .color),
            completions: try container.decode([Log].self, forKey: .completions),
            createdDate: try container.decode(Date.self, forKey: .createdDate),
            dailyGoal: try container.decode(Double.self, forKey: .dailyGoal)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(color, forKey: .color)
        try container.encode(completions, forKey: .completions)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(dailyGoal, forKey: .dailyGoal)
    }
}

extension Log: Codable {
    enum CodingKeys: String, CodingKey {
        case time
        case amount
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(
            time: try container.decode(Date.self, forKey: .time),
            amount: try container.decode(Double.self, forKey: .amount)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(time, forKey: .time)
        try container.encode(amount, forKey: .amount)
    }
}

