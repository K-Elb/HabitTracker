//
//  WeightView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct WeightView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { habit in habit.name == "Weight"}) private var habits: [Habit]
    
    var body: some View {
        VStack {
            if let habit = habits.first {
                HabitDetail(habit: habit)
            }
        }
        .task { await addHabit() }
    }
    
    func addHabit() async {
        if !habits.contains(where: { $0.name == "Weight" }) {
            modelContext.insert(Habit(name: "Weight", icon: "number", color: "blue"))
        }
    }
}

#Preview {
    WeightView()
}
