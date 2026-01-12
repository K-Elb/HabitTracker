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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//                Text("General")
//                    .font(.title.bold())
//                    .padding(.horizontal)
                
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
                
//                Text("Health")
//                    .font(.title.bold())
//                    .padding(.horizontal)
                
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
