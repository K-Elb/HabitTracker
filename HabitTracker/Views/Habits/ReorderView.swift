//
//  ReorderView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 16/01/2026.
//

import SwiftUI
import SwiftData

struct ReorderView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var habits: [Habit]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits) { habit in
                    Label(habit.name, systemImage: habit.icon)
                        .listItemTint(Color.from(string: habit.color))
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .navigationTitle("Habits List")
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
            }
            .task { await addHabits() }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        habits.move(fromOffsets: source, toOffset: destination)
        
        for index in habits.indices {
            habits[index].sortOrder = index
        }
    }
    
    func delete(offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(habits[offset])
        }
        
        habits.remove(atOffsets: offsets)
    }
    
    func addHabits() async {
        let fetchDescriptor = FetchDescriptor<Habit>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            habits.append(Habit(sortOrder: 3, name: "Reading", icon: "book.fill", color: "mint"))
            habits.append(Habit(sortOrder: 4, name: "Exercise", icon: "dumbbell.fill", color: "indigo"))
            habits.append(Habit(sortOrder: 5, name: "Meditate", icon: "apple.meditate", color: "green"))
            
            habits.append(Habit(sortOrder: 0, name: "Water", icon: "waterbottle.fill", color: "cyan", dailyGoal: 2500))
            habits.append(Habit(sortOrder: 2, name: "Weight", icon: "figure", color: "orange"))
            habits.append(Habit(sortOrder: 1, name: "Calories", icon: "flame.fill", color: "red", dailyGoal: 2200))
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @Query var habits: [Habit]
    ReorderView(habits: habits)
}
