//
//  HabitsView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]
    
    // MARK: Data Owned by Me
    @State private var habitToEdit: Habit?
    @State private var showAddHabit = false
    @State private var showOrderList = false
    @State private var search: String = ""
    @State private var showFilePicker = false
    
//    var sampleGamesURLS: [URL] {
//        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
//            .map { URL(filePath: $0) }
//    }
    
    var body: some View {
        NavigationStack {
            HabitsList(search: search)
                .navigationTitle("Habits")
                .searchable(text: $search, prompt: Text("Search habits"))
                .toolbar {
                    ToolbarItem {
                        ToolbarButtons
                    }

                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("New habit", systemImage: "plus") {
                            habitToEdit = Habit(sortOrder: habits.count, name: "", icon: "figure.walk.suitcase.rolling", color: "255,56,60", dailyGoal: 1)
                        }
                    }
                }
                .task {
                    #if targetEnvironment(simulator)
                    await addSampleHabits()
                    #endif
                }
        }
    }
    
    var ToolbarButtons: some View {
        Menu {
            Button("Edit habits", systemImage: "list.bullet") {
                showOrderList = true
            }
            Button("Export all habits", systemImage: "square.and.arrow.up") {
                saveHabits()
            }
            Button("Load habit", systemImage: "square.and.arrow.down") {
                showFilePicker = true
            }
        } label: {
            Image(systemName: "ellipsis")
        }
        .sheet(isPresented: $showOrderList) {
            ReorderView(habits: habits)
        }
        .sheet(isPresented: showHabitEditor) {
            habitEditor
        }
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [UTType.json], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                guard let selectedURL = urls.first else { return }
                processPickedFile(at: selectedURL)
            case .failure(let error):
                print("Error selecting file: \(error.localizedDescription)")
            }
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
                dailyGoal: habitToEdit.dailyGoal,
                type: habitToEdit.type
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
            
            modelContext.insert(Habit(sortOrder: 0, name: "Water", icon: "waterbottle.fill", color: "cyan", dailyGoal: 2500, type: "multiple"))
            modelContext.insert(Habit(sortOrder: 2, name: "Weight", icon: "figure", color: "orange", dailyGoal: 70.0, type: "onceWithValue"))
            modelContext.insert(Habit(sortOrder: 1, name: "Calories", icon: "flame.fill", color: "red", dailyGoal: 2200, type: "multiple"))
        }
    }
    
    func saveHabits() {
        for habit in habits {
            if let json = try? JSONEncoder().encode(habit) {
                let url = URL.documentsDirectory.appendingPathComponent(habit.name).appendingPathExtension("json")
                try? json.write(to: url)
            }
        }
    }
    
    //Access the file securely
    private func processPickedFile(at url: URL) {
        // Gain temporary security-scoped access to the sandbox-restricted URL
        let hasAccess = url.startAccessingSecurityScopedResource()
        
        // Ensure the resource is released when this block finishes executing
        defer {
            if hasAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        if hasAccess {
            Task {
                await loadHabits(url: url)
            }
        } else {
            print("Permission denied to access file.")
        }
    }
    
    func loadHabits(url: URL) async {
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            let habit = try JSONDecoder().decode(Habit.self, from: json)
            if habits.contains(where: { $0.name == habit.name }) { print("Habit already exists"); return }
            modelContext.insert(habit)
            print("Loaded habit from \(url)")
        } catch {
            print("Couldn't load habit: \(error.localizedDescription)")
        }
    }
}

#Preview(traits: .swiftData) {
    HabitsView()
}
