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
            TabView {
                Tab {
                    HabitsView()
                } label: {
                    Label("Habits", systemImage: "rectangle.stack")
                }
                Tab {
                    WaterView()
                } label: {
                    Label("Water", systemImage: "waterbottle")
                }
                Tab {
                    WeightView()
                } label: {
                    Label("Weight", systemImage: "figure")
                }
                Tab {
                    CaloriesView()
                } label: {
                    Label("Calories", systemImage: "flame")
                }
            }
            .modelContainer(for: Habit.self)
        }
    }
}
