//
//  DataPicker.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 15/01/2026.
//

import SwiftUI
import SwiftData

struct DataPicker: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var habit: Habit
    
    @State private var height: CGFloat = 0.5
    @State private var amount: Int = 100
    @FocusState private var isFocused: Bool
    
    var color: Color {
        Color.from(string: habit.color)
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 8)
                    .padding(8)
                    .foregroundStyle(color)
                    .frame(height: 240 * height)
            }
            .frame(maxWidth: 100, maxHeight: 240)
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
            .background(color)
            .clipShape(.capsule)
            .padding(.horizontal)
        }
        .presentationDetents([.medium, .large])
    }
    
    func addWater() {
        habit.addCompletion(Date(),of: Double(amount))
        isFocused = false
        dismiss()
    }
    
    func dragPicker() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let actual = value.location.y/240
                let percentage = max(0.2, min(0.95, 1-actual))
                height = percentage
                amount = Int(height*43)*10
            }
    }
}

#Preview {
    DataPicker(habit: Habit(sortOrder: 0, name: "Water", icon: "waterbottle", color: "blue"))
}
