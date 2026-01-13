//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HabitsView()
                .modelContainer(for: Habit.self)
        }
    }
}
