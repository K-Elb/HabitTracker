//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 10/01/2026.
//


import SwiftUI
import SwiftData

struct HabitRow: View {
    let habit: Habit
    var isDetailed: Bool = false
    
    @State private var isShowingSheet: Bool = false
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: habit.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.wb)
                    .padding(8)
                
                if habit.isDefault {
                    let amount = habit.name == "Weight" ? String(habit.totalOnThisDay(selectedDate)) : String(Int(habit.totalOnThisDay(selectedDate)))
                    Text("\(amount) \(habit.unit)")
                        .font(.title.bold())
                        .foregroundStyle(.wb)
                }
                
                Spacer()
                
                Button(action: { addHabitEntry() }) {
                    Circle()
                        .foregroundStyle(habit.isCompletedOnThisDay(selectedDate) ? .clear : .wb)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: habit.isCompletedOnThisDay(selectedDate) ? "checkmark" : "plus")
                                .font(.title2.bold())
                                .foregroundStyle(habit.isCompletedOnThisDay(selectedDate) ? .wb : Color.from(string: habit.color))
                                .contentTransition(.symbolEffect(.replace))
                        }
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $isShowingSheet) {
                    switch habit.name {
                    case "Water", "Calories", "Weight": DataPicker(habit: habit, selectedDate: selectedDate)
                    default: EmptyView()
                    }
                }
            }
            .frame(height: 48)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    HStack {
                        Label("\(habit.sortOrder)", systemImage: "list.number")
                        Label("\(habit.completions.count)", systemImage: "number")
                        Label("\(habit.currentStreak())", systemImage: "flame.fill")
                        if habit.dailyGoal != 1 {
                            Label("\(Int(habit.dailyGoal))", systemImage: "target")
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                }
                .foregroundStyle(Color.from(string: habit.color))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .bold()
            .padding(16)
            .frame(height: 160)
            .background(.wb)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            
            if isDetailed {
                WeekView(habit: habit, selectedDate: $selectedDate)
            }
        }
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal)
    }
    
    func addHabitEntry() {
        switch habit.name {
        case "Water", "Calories", "Weight": isShowingSheet = true
        default: habit.addCompletion(selectedDate)
        }
    }
}

struct MeshBackground: View {
    let color: Color
    var colors: [Color] { Array(repeating: color.opacity(Double.random(in: 0.2...1.0)), count: 9) }
    @State var point: SIMD2<Float> = [0.5, 0.5]
    
    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(width: 3,
                         height: 3,
                         points: [[0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                                  [0.0, 0.5], point, [1.0, 0.5],
                                  [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]],
                         colors: colors)
                .ignoresSafeArea()
                .onAppear {
                    startTimer()
                }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 2.0)) {
                point = [Float(.random(in: 0.2...0.8)), Float(.random(in: 0.2...0.8))]
//                print(point)
            }
        }
    }
}

#Preview {
    HabitRow(habit: Habit(sortOrder: 0, name: "Reading", icon: "book.fill", color: "orange"))
}
