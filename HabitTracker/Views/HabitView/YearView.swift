//
//  YearView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 13/01/2026.
//

import SwiftUI
import Charts

struct TaskCompletion {
    var date: Date
    var x: Int
    var y: Int
    var value: Double
}

@Observable
final class YearViewModel {
    let habit: Habit
    var year: Int {
            didSet { rebuild() }
        }

    init(habit: Habit, year: Int) {
        self.habit = habit
        self.year = year
        rebuild()
    }
    
    var days: [TaskCompletion] = []
    let calendar = Calendar.current
    
    func isOldestYear() -> Bool {
        let oldestDate = habit.logs.map(\.time).min() ?? Date()
        if calendar.component(.year, from: oldestDate) == year {
            return true
        }
        return false
    }
    
    func isThisYear() -> Bool {
        if calendar.component(.year, from: Date()) == year {
            return true
        }
        return false
    }
    
    func setYear(_ newYear: Int) {
        year = newYear
        rebuild()
    }
    
    func nextYear() {
        year += 1
    }
    
    func previousYear() {
        year -= 1
    }

    private func rebuild() {
        days = buildDays(for: year)
    }
    
    func buildDays(for year: Int) -> [TaskCompletion] {
        guard
            let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
            let end = calendar.date(from: DateComponents(year: year, month: 12, day: 31))
        else { return [] }

        let totals = totalsByDay(calendar: calendar)

        var results: [TaskCompletion] = []
        results.reserveCapacity(365)

        var current = start
        while current <= end {
            let day = calendar.startOfDay(for: current)
            let comps = calendar.dateComponents([.month, .day], from: day)

            results.append(
                TaskCompletion(
                    date: day,
                    x: comps.month!,
                    y: -comps.day!,
                    value: totals[day, default: 0]
                )
            )

            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return results
    }
    
    func totalsByDay(calendar: Calendar = .current) -> [Date: Double] {
        var result: [Date: Double] = [:]

        for log in habit.logs {
            let day = calendar.startOfDay(for: log.time)
            result[day, default: 0] += log.amount
        }

        return result
    }
}

struct YearView: View {
    let habit: Habit
    
    @State private var viewModel: YearViewModel

    init(habit: Habit) {
        self.habit = habit
        
        let currentYear = Calendar.current.component(.year, from: .now)
        _viewModel = State(
            wrappedValue: YearViewModel(
                habit: habit,
                year: currentYear
            )
        )
    }
    
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
    
    

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: (UIScreen.main.bounds.width)/18) {
                ForEach(months.indices, id: \.self) { index in
                    Text(months[index])
                }
            }
            .padding(.top)
            .font(.caption.bold())
            .foregroundStyle(color)
            
            Chart(viewModel.days, id: \.date) { data in
                let w  = MarkDimension(floatLiteral: 18)
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
                if !viewModel.isOldestYear() {
                    Button(action: { viewModel.previousYear() }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                Spacer()
                if !viewModel.isThisYear() {
                    Button(action: { viewModel.nextYear() }) {
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 24)
            .overlay {
                Text(String(viewModel.year))
            }
            .bold()
            .foregroundStyle(color)
        }
    }
}

#Preview {
    YearView(habit: Habit(sortOrder: 0, name: "Test", icon: "flame", color: "red", dailyGoal: 3.0))
}
