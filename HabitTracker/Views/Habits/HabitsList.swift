//
//  HabitsList.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct HabitsList: View {
    @Query private var habits: [Habit]
    
    @Namespace var transition
    @State private var stacked: Bool = true
    @State private var selectedHabit: Habit?
    @State private var refreshID = UUID()
    
    init(search: String = "") {
        let predicate = #Predicate<Habit> { habit in
            search.isEmpty || habit.name.contains(search)
        }
        _habits = Query(filter: predicate, sort: \Habit.sortOrder)
    }
    
    var body: some View {
        if habits.isEmpty {
            ContentUnavailableView("No Habits Available ", systemImage: "xmark.circle", description: Text("Start building better habits today"))
        } else {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(0..<habits.count, id: \.self) { index in
                        let habit = habits[index]
                        // MARK: - Option 1
//                                            NavigationLink {
//                                                HabitDetail(habit: habit)
//                                                    .navigationTransition(.zoom(sourceID: habit.id, in: transition))
//                                            } label: {
//                                                HabitRow(habit: habit, isDetailed: false)
//                                            }
//                                            .matchedTransitionSource(id: habit.id, in: transition)
//                                            .frame(height: stacked ? 128 : .infinity)
//                                            .offset(y: CGFloat(132*index))
                        
                        // MARK: - Option 2
                        //                    NavigationLink(value: habit) {
                        //                        HabitRow(habit: habit, isDetailed: false)
                        //                    }
                        //                    .navigationDestination(for: Habit.self) { habit in
                        //                        HabitDetail(habit: habit)
                        //                            .navigationTransition(.zoom(sourceID: habit, in: transition))
                        //                            .onDisappear {
                        //                                refreshID = UUID()
                        //                            }
                        //                    }
                        //                    .matchedTransitionSource(id: habit, in: transition)
                        //                    .offset(y: CGFloat(60*index))
                        
                        // MARK: - Option 3
                        Button(action: {selectedHabit = habit}) {
                            HabitRow(habit: habit, isDetailed: false)
                                .matchedTransitionSource(id: habit, in: transition)
                        }
                        .buttonStyle(.plain)
                        .fullScreenCover(item: $selectedHabit) { habit in
                            HabitDetail(habit: habit)
                                .navigationTransition(.zoom(sourceID: habit, in: transition))
                        }
                        .frame(height: stacked ? 64 : .infinity)
                    }
                }
                .padding(.vertical, stacked ? 76 : 0)
//                .id(refreshID)
                .toolbar {
                    ToolbarSpacer()
                    
                    ToolbarItem {
                        Button(action: { withAnimation{stacked.toggle()} }) {
                            Image(systemName: stacked ? "rectangle.stack.fill" : "rectangle.fill")
                        }
                        .contentTransition(.symbolEffect(.automatic))
                    }
                }
            }
        }
    }
}

//#Preview {
//    HabitsList()
//}
