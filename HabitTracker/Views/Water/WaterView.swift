//
//  WaterView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI
import SwiftData

struct WaterView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { habit in habit.name == "Water"}) private var habits: [Habit]
    
    var body: some View {
        VStack {
            if let habit = habits.first {
                HabitDetail(habit: habit)
                
                WaterPicker(habit: habit)
            }
        }
        .task { await addHabit() }
    }
    
    func addHabit() async {
        if !habits.contains(where: { $0.name == "Water" }) {
            modelContext.insert(Habit(name: "Water", icon: "number", color: "blue"))
        }
    }
}

struct WaterPicker: View {
    @Environment(\.modelContext) private var modelContext
    
    var habit: Habit
    
    @State private var height: CGFloat = 0.5
    
    var body: some View {
        Text("\(Int(height*20)*20) ml")
            .font(.largeTitle.weight(.light))
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .padding()
                    .foregroundStyle(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 8)
                    .padding()
                    .foregroundStyle(Color.from(string: "blue"))
                    .frame(height: geometry.size.height * height)
            }
            .gesture(dragPicker(geometry.size.height))
        }
        
        Button("Add", systemImage: "waterbottle") {
            addWater()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.from(string: "blue"))
        .clipShape(.capsule)
        .padding()
    }
    
    func addWater() {
        let amount = Int(height*20)
        habit.add(Double(amount))
    }
    
    func dragPicker(_ height: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let actual = value.location.y/height
                let percentage = max(0.2, min(0.95, 1-actual))
                self.height = percentage
            }
    }
}


#Preview(traits: .swiftData) {
    WaterView()
}
