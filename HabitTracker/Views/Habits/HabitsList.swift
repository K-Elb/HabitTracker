//
//  HabitsList.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitsList: View {
    var habits: [Habit]
    
    @Namespace var transition
    @State private var expanded: Bool = false
    @State private var selectedHabit: Habit?
    @State private var refreshID = UUID()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                ForEach(0..<habits.count, id: \.self) { index in
                    let habit = habits[index]
                    // MARK: - Option 1
//                    NavigationLink {
//                        HabitDetail(habit: habit)
//                            .navigationTransition(.zoom(sourceID: habit.id, in: transition))
//                    } label: {
//                        HabitDetail(habit: habit, isDetailed: false)
//                    }
//                    .matchedTransitionSource(id: habit.id, in: transition)
                    
                    // MARK: - Option 2
                    NavigationLink(value: habit) {
                        HabitDetail(habit: habit, isDetailed: false)
                    }
                    .navigationDestination(for: Habit.self) { habit in
                        HabitDetail(habit: habit)
                            .navigationTransition(.zoom(sourceID: habit, in: transition))
                            .onDisappear {
                                refreshID = UUID()
                            }
                    }
                    .matchedTransitionSource(id: habit, in: transition)
                    .offset(y: CGFloat(60*index))
                
                    // MARK: - Option 3
//                    Button(action: {selectedHabit = habit}) {
//                        HabitDetail(habit: habit, isDetailed: false)
//                            .matchedTransitionSource(id: habit, in: transition)
//                    }
//                    .fullScreenCover(item: $selectedHabit) { habit in
//                        HabitDetail(habit: habit)
//                            .navigationTransition(.zoom(sourceID: habit, in: transition))
//                    }
//                    .offset(y: CGFloat(60*index))
                }
            }
            .id(refreshID)
        }
    }
}

//#Preview {
//    HabitsList()
//}
