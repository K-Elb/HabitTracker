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
    
    @State private var value: Double = 250
    @State private var textInput: String = "250"
    @State private var isTapped: Bool = false

    @FocusState private var isFocused: Bool
    
    let maxCharacters = 4
    
    var body: some View {
        VStack {
            SliderShape(habit: habit, value: $value, textInput: $textInput)
                .sensoryFeedback(.selection, trigger: value)
            
            HStack(spacing: 0) {
                TextField("", text: $textInput)
                    .padding(.horizontal)
                    .focused($isFocused)
                    .keyboardType(habit.isAmountInt ? .numberPad : .decimalPad)
                    .multilineTextAlignment(.trailing)
                    .scrollDismissesKeyboard(.immediately)
                    .onChange(of: textInput) { oldValue, newValue in
                        if let doubleValue = Double(newValue), newValue.count <= maxCharacters {
                            value = doubleValue
                        } else if newValue.isEmpty {
                            value = 1
                        } else {
                            textInput = String(newValue.prefix(maxCharacters))
                        }
                    }
                
                Text(habit.unit)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: 48).bold())
            .foregroundStyle(.wb)
            
            Button(action: {add()}) {
                Label("Add", systemImage: "plus")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.from(string: habit.color))
            }
            .font(.title2.bold())
            .padding()
            .background(.wb)
            .clipShape(.capsule)
            .sensoryFeedback(.impact, trigger: isTapped)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.from(string: habit.color))
    }
    
    func add() {
        isTapped.toggle()
        habit.addCompletion(selectedDate, of: value)
        dismiss()
    }
}

struct SliderShape: View {
    var habit: Habit
    @Binding var value: Double
    @Binding var textInput: String

    @State private var height: CGFloat = 0.5
    @FocusState private var isFocused: Bool
    
    var dragPicker: some Gesture {
        DragGesture()
            .onChanged { newValue in
                let actual = newValue.location.y/pHeight
                let percentage = max(0.1, min(1, 1-actual))
                height = percentage
                if habit.name == "Weight" {
                    value = valueDouble(from: 65, to: 80, by: 0.1)
                } else {
                    value = valueInt(from: 0, to: 500, by: 25) //Double(Int(height*20)*25)
                }
                textInput = habit.isAmountInt ? String(Int(value)) : String(value)
            }
    }
    var color: Color {
        Color.from(string: habit.color)
    }
    let maxCharacters = 4
    let pHeight = UIScreen.main.bounds.width - 32
    let pWidth = 100.0
    
    var body: some View {
        switch habit.name {
        case "Water":
            CupSlider(color: color, height: height)
                .gesture(dragPicker)
        case "Weight":
            WeightSlider(color: color, height: height)
                .gesture(dragPicker)
                .onAppear {
                    value = 72.5
                    textInput = "72.5"
                }
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
            .gesture(dragPicker)
        }
    }
    
//    func heightValue(from min: Double, to max: Double, by step: Double) -> Double {
//        let scaled = min + height * (max - min)
//        let rounded = (scaled / step).rounded() * step
//        return rounded
//    }
    
    func valueDouble(from min: Int, to max: Int, by step: Double) -> Double {
        let minTenths = min * 10
        let maxTenths = max * 10
        let steps = maxTenths - minTenths
        let stepIndex = Int((height * Double(steps)).rounded())
        let valueTenths = minTenths + stepIndex
        return Double(valueTenths) / 10.0
    }
    
    func valueInt(from min: Int, to max: Int, by step: Int) -> Double {
        let steps = (max - min) / step
        let stepIndex = Int((height * Double(steps)).rounded())
        return Double(min + stepIndex * step)
    }
}

struct CupSlider: View {
    let color: Color
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Cup()
                .stroke(lineWidth: 10)
                .foregroundStyle(.wb)
                .aspectRatio(1, contentMode: .fit)
            
            Cup()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: color, location: height),
                        .init(color: .wb, location: height)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct WeightSlider: View {
    let color: Color
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Weight()
                .stroke(lineWidth: 10)
                .foregroundStyle(.wb)
                .aspectRatio(1, contentMode: .fit)
            
            Weight()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: color, location: height),
                        .init(color: .wb, location: height)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    AddEntry(habit: Habit(sortOrder: 0, name: "Water", icon: "waterbottle", color: "blue"), selectedDate: Date())
}
