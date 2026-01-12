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
            ForEach(habits) { habit in
                if habit.icon != "number" {
                    NavigationLink {
                        VStack {
                            HabitRow(habit: habit, height: 120)
                                .navigationTransition(.zoom(sourceID: habit.id, in: transition))
                            
                            ScrollView {
                                VStack {
                                    Text(habit.name)
                                }
                            }
                        }
                    } label: {
                        HabitRow(habit: habit)
                            .contextMenu {
                                Button("Delete") {
                                    deleteHabit(habit)
                                }
                            }
                    }
                    .matchedTransitionSource(id: habit.id, in: transition)
                }
            }
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        modelContext.delete(habit)
    }
}

//#Preview {
//    HabitsList()
//}
