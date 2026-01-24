//
//  DataPicker.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 15/01/2026.
//

import SwiftUI
import SwiftData

struct AddEntry: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var habit: Habit
    let selectedDate: Date
    
    @State private var amount: Double = 250
    
    var body: some View {
        VStack {
            SliderShape(habit: habit, amount: $amount)
            
            Button("Add", systemImage: "plus") {
                add()
            }
            .font(.title3.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.from(string: habit.color))
            .clipShape(.capsule)
        }
        .padding(.horizontal)
    }
    
    func add() {
        habit.addCompletion(selectedDate, of: amount)
        dismiss()
    }
}

struct SliderShape: View {
    var habit: Habit
    @Binding var amount: Double

    @State private var height: CGFloat = 0.5
    @State private var textInput: String = "250"
    @FocusState private var isFocused: Bool
    
    var color: Color {
        Color.from(string: habit.color)
    }
    let maxCharacters = 4
    let pHeight = 360.0
    let pWidth = 100.0
    
    var body: some View {
        switch habit.name {
        case "Water":
            Cup()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: color, location: height),
                        .init(color: .gray.opacity(0.1), location: height)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .aspectRatio(1, contentMode: .fit)
                .gesture(dragPicker())
        case "Weight":
            Weight()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: color, location: height),
                        .init(color: .gray.opacity(0.1), location: height)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .aspectRatio(1, contentMode: .fit)
                .gesture(dragPicker())
        default:
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
        }
        
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
            
            Text(habit.unit)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.system(size: 48).bold())
        .onAppear {
            if habit.name == "Weight" {
                amount = 72.5
                textInput = "72.5"
            }
        }
    }
    
    func dragPicker() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let actual = value.location.y/pHeight
                let percentage = max(0.1, min(1, 1-actual))
                height = percentage
                if habit.name == "Weight" {
                    amount = height*15 + 65
                } else {
                    amount = Double(Int(height*20)*25)
                }
                textInput = habit.isAmountInt ? String(Int(amount)) : String(amount)
            }
    }
}

#Preview {
    AddEntry(habit: Habit(sortOrder: 0, name: "Weight", icon: "waterbottle", color: "blue"), selectedDate: Date())
}
