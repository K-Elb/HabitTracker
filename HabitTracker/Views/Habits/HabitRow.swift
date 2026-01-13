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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: habit.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.wb)
                    .padding(8)
                
                Spacer()
                
                Button(action: { habit.toggleCompletion() }) {
                    Circle()
                        .foregroundStyle(habit.isCompletedToday() ? .clear : .wb)
                        .frame(width: 48)
                        .overlay {
                            Image(systemName: habit.isCompletedToday() ? "checkmark" : "plus")
                                .font(.title2.bold())
                                .foregroundStyle(habit.isCompletedToday() ? .wb : Color.from(string: habit.color))
                                .contentTransition(.symbolEffect(.replace))
                        }
                }
                .buttonStyle(.plain)
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.title)
                    
                    Spacer()
                    
                    HStack {
                        Label("\(habit.completions.count)", systemImage: "sum")
                            .font(.caption)
                        
                        Label("\(habit.currentStreak())", systemImage: "flame")
                            .font(.caption)
                        
                        Spacer()
                        
                        Text("\(habit.createdDate, style: .date)")
                            .font(.caption)
                    }
                    .padding(.horizontal, 4)
                }
                .foregroundStyle(.wb)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .bold()
            .padding(12)
            .frame(height: 120)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .padding(8)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal)
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
    HabitRow(habit: Habit(name: "Reading", icon: "book.fill", color: "orange"))
}
