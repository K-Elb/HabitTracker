//
//  YearView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 13/01/2026.
//

import SwiftUI
import Charts

struct TaskCompletion {
    let date: Date
    let x: Int
    let y: Int
    let value: Double
}

struct YearView: View {
    let habit: Habit
    @Binding var year: Int

    private let calendar = Calendar.current
    private let circleSize: CGFloat = 10
    private let spacing: CGFloat = 0
    
    private let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    
    var color: Color { Color.from(string: habit.color) }
    var colorRange: [Color] {
        if habit.dailyGoal == 1 {
            return [color]
        } else {
            return [color.opacity(0.2), color.opacity(0.6), color]
        }
    }
    
    var oldestYear: Int {
        let oldestDate = habit.completions.map(\.time).min() ?? Date()
        return calendar.component(.year, from: oldestDate)
    }
    var latestYear: Int {
        calendar.component(.year, from: Date())
    }


    var body: some View {
        VStack {
            HStack(spacing: (UIScreen.main.bounds.width)/18) {
                ForEach(months.indices, id: \.self) { index in
                    Text(months[index])
                }
            }
            .offset(y: 12)
            .font(.caption.bold())
            .foregroundStyle(color)
            
            Chart(allDaysInYear, id: \.date) { data in
                let w  = MarkDimension(floatLiteral: 16)
                if data.value > 0 {
                    RectangleMark (
                        x: .value("x", data.x),
                        y: .value("y", data.y),
                        width: w,
                        height: w
                    )
                    .cornerRadius(16)
                    .foregroundStyle(by: .value("Number", min(habit.dailyGoal, data.value)))
                } else {
                    RectangleMark (
                        x: .value("x", data.x),
                        y: .value("y", data.y),
                        width: w,
                        height: w
                    )
                    .cornerRadius(16)
                    .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-192)
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(domain: 0...13)
            .chartYScale(domain: -32...0)
            .chartForegroundStyleScale(range: colorRange)
            
            HStack {
                if year > oldestYear {
                    Button(action: { year -= 1 }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                Spacer()
                if year < latestYear {
                    Button(action: { year += 1 }) {
                        Image(systemName: "chevron.forward")
                    }
                }
                    
            }
            .padding(.horizontal, 24)
            .overlay {
                Text(String(year))
            }
            .bold()
            .foregroundStyle(color)
        }
    }

    private var allDaysInYear: [TaskCompletion] {
        guard
            let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
            let end = calendar.date(from: DateComponents(year: year, month: 12, day: 31))
        else { return [] }

        var dates: [TaskCompletion] = []
        var current = start
        
        while current <= end {
            dates.append(
                TaskCompletion(
                    date: current,
                    x: calendar.component(.month, from: current),
                    y: -calendar.component(.day, from: current),
                    value: habit.totalOnThisDay(current) //Double(Int.random(in: 0...4))
                )
            )
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }
}

#Preview {
    @Previewable @State var year = 2026
    YearView(habit: Habit(sortOrder: 0, name: "Test", icon: "flame", color: "red", dailyGoal: 3.0), year: $year)
}
