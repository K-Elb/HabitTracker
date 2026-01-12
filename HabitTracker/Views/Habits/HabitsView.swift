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
    @Query private var habits: [Habit]
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    emptyStateView()
                } else {
                    HabitsList()
                }
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
            .task { await addHabits() }
        }
    }
    
    func emptyStateView() -> some View {
        VStack {
            ContentUnavailableView("No Habits Yet", systemImage: "checkmark.circle", description: Text("Start building better habits today"))
            
            Button(action: { showingAddHabit = true }) {
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
            modelContext.insert(Habit(name: "Reading", icon: "book.fill", color: "mint"))
            modelContext.insert(Habit(name: "Exercise", icon: "dumbbell.fill", color: "indigo"))
            modelContext.insert(Habit(name: "Meditate", icon: "apple.meditate", color: "green"))
        }
        if !habits.contains(where: { $0.name == "Water" }) {
            modelContext.insert(Habit(name: "Water", icon: "waterbottle.fill", color: "cyan"))
        }
        if !habits.contains(where: { $0.name == "Weight" }) {
            modelContext.insert(Habit(name: "Weight", icon: "figure", color: "orange"))
        }
        if !habits.contains(where: { $0.name == "Calories" }) {
            modelContext.insert(Habit(name: "Calories", icon: "flame.fill", color: "red"))
        }
    }
}

#Preview(traits: .swiftData) {
    HabitsView()
}
