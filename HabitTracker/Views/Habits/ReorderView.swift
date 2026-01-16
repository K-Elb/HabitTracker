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
        List {
            ForEach(habits) { habit in
                Text(habit.name)
            }
            .onMove(perform: move)
        }
        .toolbar {
            ToolbarItem {
                EditButton()
                
                Button("Save") {
                    save()
                }
            }
        }
//        .task { await addHabits() }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        habits.move(fromOffsets: source, toOffset: destination)
        
        for index in habits.indices {
            habits[index].sortOrder = index
        }
    }
    
    func save() {
        
    }
}

//#Preview(traits: .swiftData) {
//    NavigationStack {
//        ReorderView()
//    }
//}
