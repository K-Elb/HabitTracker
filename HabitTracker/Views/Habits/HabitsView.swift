//
//  HabitsView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]
    @State private var showAddHabit = false
    @State private var showOrderList = false
    
    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    emptyStateView()
                } else {
                    HabitsList(habits: habits)
                }
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: { showAddHabit = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { showOrderList = true }) {
                        Image(systemName: "list.number")
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(habitsCount: habits.count)
            }
            .sheet(isPresented: $showOrderList) {
                ReorderView(habits: habits)
            }
            .task { await addHabits() }
        }
    }
    
    func emptyStateView() -> some View {
        VStack {
            ContentUnavailableView("No Habits Yet", systemImage: "checkmark.circle", description: Text("Start building better habits today"))
            
            Button(action: { showAddHabit = true }) {
                Text("Add Your First Habit")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    func addHabits() async {
        let fetchDescriptor = FetchDescriptor<Habit>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(Habit(sortOrder: 3, name: "Reading", icon: "book.fill", color: "mint"))
            modelContext.insert(Habit(sortOrder: 4, name: "Exercise", icon: "dumbbell.fill", color: "indigo"))
            modelContext.insert(Habit(sortOrder: 5, name: "Meditate", icon: "apple.meditate", color: "green"))
            
            modelContext.insert(Habit(sortOrder: 0, name: "Water", icon: "waterbottle.fill", color: "cyan", dailyGoal: 2500))
            modelContext.insert(Habit(sortOrder: 2, name: "Weight", icon: "figure", color: "orange"))
            modelContext.insert(Habit(sortOrder: 1, name: "Calories", icon: "flame.fill", color: "red", dailyGoal: 2200))
        }
//        if !habits.contains(where: { $0.name == "Water" }) {
//            modelContext.insert(Habit(name: "Water", icon: "waterbottle.fill", color: "cyan", dailyGoal: 2500))
//        }
//        if !habits.contains(where: { $0.name == "Weight" }) {
//            modelContext.insert(Habit(name: "Weight", icon: "figure", color: "orange"))
//        }
//        if !habits.contains(where: { $0.name == "Calories" }) {
//            modelContext.insert(Habit(name: "Calories", icon: "flame.fill", color: "red", dailyGoal: 2200))
//        }
    }
}

#Preview(traits: .swiftData) {
    HabitsView()
}
