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
    let selectedDate: Date
    
    @State private var height: CGFloat = 0.5
    @State private var amount: Double = 250
    @State private var textInput: String = "250"
    @FocusState private var isFocused: Bool
    
    var color: Color {
        Color.from(string: habit.color)
    }
    let maxCharacters = 4
    let pHeight = 360.0
    let pWidth = 100.0
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 8)
                    .padding(8)
                    .foregroundStyle(color)
                    .frame(height: pHeight * height)
            }
            .frame(maxWidth: pWidth, maxHeight: pHeight)
            .gesture(dragPicker())
            
            HStack(spacing: 0) {
                TextField("", text: $textInput)
                    .padding()
                    .focused($isFocused)
                    .keyboardType(habit.isAmountInt ? .numberPad : .decimalPad)
                    .multilineTextAlignment(.trailing)
                    .scrollDismissesKeyboard(.immediately)
                    .onChange(of: textInput) { oldValue, newValue in
                        if let doubleValue = Double(newValue), newValue.count <= maxCharacters {
                            amount = doubleValue
                        } else if newValue.isEmpty {
                            amount = 1
                        } else {
                            textInput = String(newValue.prefix(maxCharacters))
                        }
                    }
                
//                if habit.isAmountInt {
//                    Text("\(Int(amount))")
//                        .onTapGesture { isFocused = true }
//                } else {
//                    Text("\(amount, specifier: "%.1f")")
//                        .onTapGesture { isFocused = true }
//                }
                
                Text(habit.unit)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: 48).bold())
            
            Spacer()
            
            Button("Add", systemImage: "plus") {
                add()
            }
            .font(.title3.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .clipShape(.capsule)
        }
        .padding(.horizontal)
        .onAppear {
            if habit.name == "Weight" {
                amount = 75.0
                textInput = "75.0"
            }
        }
//        .presentationDetents([.medium, .large])
    }
    
    func add() {
        habit.addCompletion(selectedDate, of: amount)
        isFocused = false
        dismiss()
    }
    
    func dragPicker() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let actual = value.location.y/pHeight
                let percentage = max(0.1, min(1, 1-actual))
                height = percentage
                if habit.name == "Weight" {
                    amount = height*50 + 50
                } else {
                    amount = height*500
                }
                textInput = habit.isAmountInt ? String(Int(amount)) : String(amount)
            }
    }
}

#Preview {
    DataPicker(habit: Habit(sortOrder: 0, name: "Weight", icon: "waterbottle", color: "blue"), selectedDate: Date())
}
