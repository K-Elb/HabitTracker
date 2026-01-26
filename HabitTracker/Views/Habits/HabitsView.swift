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
    
    // MARK: Data Owned by Me
    @State private var habitToEdit: Habit?
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
//            .navigationTitle("Habits")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                addButton
                editHabits
            }
            .task { await addSampleHabits() }
        }
    }
    
    // MARK: - Habits List
    var editHabits: some View {
        Button("Edit habits", systemImage: "list.bullet") {
            showOrderList = true
        }
        .sheet(isPresented: $showOrderList) {
            ReorderView(habits: habits)
        }
    }
    
    // MARK: - Add Habit
    var addButton: some View {
        Button("Add Habit", systemImage: "plus") {
            habitToEdit = Habit(sortOrder: habits.count, name: "", icon: "figure", color: "blue", dailyGoal: 1)
        }
        .sheet(isPresented: showHabitEditor) {
            habitEditor
        }
    }
    
    @ViewBuilder
    var habitEditor: some View {
        if let habitToEdit {
            let copyOfHabitToEdit = Habit(
                sortOrder: habitToEdit.sortOrder,
                name: habitToEdit.name,
                icon: habitToEdit.icon,
                color: habitToEdit.color,
                dailyGoal: habitToEdit.dailyGoal
            )
            
            HabitEditor(habit: copyOfHabitToEdit) {
                if habits.contains(habitToEdit) {
                    modelContext.delete(habitToEdit)
                }
                modelContext.insert(copyOfHabitToEdit)
            }
        }
    }
    
    var showHabitEditor: Binding<Bool> {
        Binding<Bool>(
            get: { habitToEdit != nil },
            set: { newValue in
                if !newValue {
                    habitToEdit = nil
                }
            }
        )
    }
    
    // MARK: - Other
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
    
    func addSampleHabits() async {
        let fetchDescriptor = FetchDescriptor<Habit>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(Habit(sortOrder: 3, name: "Reading", icon: "book.fill", color: "mint"))
            modelContext.insert(Habit(sortOrder: 4, name: "Exercise", icon: "dumbbell.fill", color: "indigo"))
            modelContext.insert(Habit(sortOrder: 5, name: "Meditate", icon: "apple.meditate", color: "green"))
            
            modelContext.insert(Habit(sortOrder: 0, name: "Water", icon: "waterbottle.fill", color: "cyan", dailyGoal: 2500))
            modelContext.insert(Habit(sortOrder: 2, name: "Weight", icon: "figure", color: "orange"))
            modelContext.insert(Habit(sortOrder: 1, name: "Calories", icon: "flame.fill", color: "red", dailyGoal: 2200))
        }
    }
    
//    func loadSampleGames() async {
//        for url in sampleGamesURLS {
//            do {
//                let (json, _) = try await URLSession.shared.data(from: url)
//                let game = try JSONDecoder().decode(Habit.self, from: json)
//                modelContext.insert(game)
//                print("Loaded sample games from \(url)")
//            } catch {
//                print("Couldn't load a sample game: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    var sampleGamesURLS: [URL] {
//        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
//            .map { URL(filePath: $0) }
//    }
}

#Preview(traits: .swiftData) {
    HabitsView()
}
