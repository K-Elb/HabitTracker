//
//  HabitsList.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.name) private var habits: [Habit]
    
    @Namespace var transition
    
    @State private var expanded: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(habits) { habit in
                    if habit.isDefault {
                        NavigationLink {
                            HabitDetail(habit: habit)
                                .navigationTransition(.zoom(sourceID: habit.id, in: transition))
                        } label: {
                            HabitDetail(habit: habit, isDetailed: false)
                        }
                        .matchedTransitionSource(id: habit.id, in: transition)
                    }
                }
                
                ForEach(habits) { habit in
                    if !habit.isDefault {
                        NavigationLink {
                            HabitDetail(habit: habit)
                                .navigationTransition(.zoom(sourceID: habit.id, in: transition))
                        } label: {
                            HabitDetail(habit: habit, isDetailed: false)
                        }
                        .matchedTransitionSource(id: habit.id, in: transition)
                    }
                }
            }
        }
    }
}



//#Preview {
//    HabitsList()
//}
