//
//  HabitsList.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitsList: View {
    @Query(sort: \Habit.name) private var habits: [Habit]
    
    @Namespace var transition
    
    var body: some View {
        ScrollView {
            ForEach(habits) { habit in
                NavigationLink {
                    HabitDetail(habit: habit)
                        .navigationTransition(.zoom(sourceID: habit.id, in: transition))
                } label: {
                    HabitRow(habit: habit)
                }
                .matchedTransitionSource(id: habit.id, in: transition)
            }
            .padding()
        }
    }
}

//#Preview {
//    HabitsList()
//}
