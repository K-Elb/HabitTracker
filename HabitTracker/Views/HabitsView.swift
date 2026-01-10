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
                    emptyStateView
                } else {
                    habitListView
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
            .task { await addSampleGames() }
        }
    }
    
    private var emptyStateView: some View {
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
    
    private var habitListView: some View {
        ScrollView {
            VStack {
                ForEach(habits) { habit in
                    HabitRow(habit: habit)
                }
            }
            .padding()
        }
    }
    
    func addSampleGames() async {
        let fetchDescriptor = FetchDescriptor<Habit>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(Habit(name: "Reading", icon: "book.fill", color: "yellow", frequency: .daily))
            modelContext.insert(Habit(name: "Exercise", icon: "dumbbell.fill", color: "indigo", frequency: .daily))
            modelContext.insert(Habit(name: "Drink water", icon: "drop.fill", color: "cyan", frequency: .daily))
        }
    }
}

#Preview(traits: .swiftData) {
    HabitsView()
}
