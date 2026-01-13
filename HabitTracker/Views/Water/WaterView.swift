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
    @State private var amount: Int = 100
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 8)
                .padding()
                .foregroundStyle(.ultraThinMaterial)
            
            RoundedRectangle(cornerRadius: 8)
                .padding()
                .foregroundStyle(Color.from(string: "blue"))
                .frame(height: 320 * height)
        }
        .frame(maxWidth: 120, maxHeight: 320)
        .gesture(dragPicker())
        
        
        HStack(spacing: 0) {
            TextField("", value: $amount, format: .number)
                .focused($isFocused)
                .keyboardType(.numberPad)
                .scrollDismissesKeyboard(.immediately)
            
            Text("ml")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.system(size: 48).bold())
        .padding(.horizontal)
        
        Button("Add", systemImage: "plus") {
            addWater()
        }
        .font(.title3.bold())
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.from(string: "blue"))
        .clipShape(.capsule)
        .padding(.horizontal)
    }
    
    func addWater() {
        habit.add(Double(amount))
        isFocused = false
    }
    
    func dragPicker() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let actual = value.location.y/320
                let percentage = max(0.2, min(0.95, 1-actual))
                height = percentage
                amount = Int(height*43)*10
            }
    }
}


#Preview(traits: .swiftData) {
    WaterView()
}
