//
//  HistoryChart.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 29/01/2026.
//

import SwiftUI
import Charts

enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
//    case all = "All"
    
    var daysBack: (Calendar.Component, Int)? {
        switch self {
        case .week: return (.day, -7)
        case .month: return (.month, -1)
        case .year: return (.year, -1)
//        case .all: return nil
        }
    }
    
//    var axisLabel: (Calendar.Component, Int) {
//        switch self {
//        case .week: return (.day, 1)
//        case .month: return (.day, 8)
//        case .year: return (.month, 1)
//        case .all: return (.year, 1)
//        }
//    }
    
    var dateFormat: Date.FormatStyle {
        switch self {
        case .week: return .dateTime.weekday(.abbreviated).day()
        case .month: return .dateTime.day().month()
        case .year: return .dateTime.year(.twoDigits).month(.narrow)
//        case .all: return .dateTime.year().month(.abbreviated)
        }
    }
}

struct HistoryChart: View {
    let habit: Habit
    @State private var selectedPeriod: TimePeriod = .week
    
    let calendar = Calendar.current

    var Logs: [Log] {
        buildDays()
    }
    
    var body: some View {
//        Text("Chart")
//            .font(.title.bold())
//            .frame(maxWidth: .infinity, alignment:.leading)
//            .foregroundStyle(.wb)
//            .padding(.top)
//            .padding(.leading, 24)
        
        VStack {
            
            
            Chart(Logs) {
                BarMark(
                    x: .value("Date", $0.time.formatted(selectedPeriod.dateFormat)),
                    y: .value("Value", $0.value)
                )
                .foregroundStyle(Color.from(string: habit.color))
            }
            .frame(height: UIScreen.main.bounds.height*0.4)
//            .chartXAxis {
//                dateXAxis(
//                    stride: selectedPeriod.axisLabel,
//                    labelFormat: selectedPeriod.dateFormat
//                )
//            }
            
            HStack {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    PeriodPicker(period)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(.wb)
//        .padding([.top, .horizontal])
    }
    
//    func dateXAxis(
//        stride: (Calendar.Component, Int),
//        labelFormat: Date.FormatStyle = .dateTime.day().month(),
//        showMinorDailyTicks: Bool = false
//    ) -> some AxisContent {
//        AxisMarks(values: .stride(by: stride.0, count: stride.1)) { _ in
//            AxisGridLine()
//            AxisTick()
//            AxisValueLabel(format: labelFormat)
//        }
//    }
    
    func PeriodPicker(_ period: TimePeriod) -> some View {
        Button(action: { selectedPeriod = period }) {
            Text(period.rawValue)
                .font(.caption.bold())
                .foregroundStyle(selectedPeriod == period ? .wb : Color.from(string: habit.color))
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(selectedPeriod == period ? Color.from(string: habit.color) : .gray.opacity(0.2), in: .capsule)
        }
    }
    
    func buildDays() -> [Log] {
        guard let daysBack = selectedPeriod.daysBack else { return habit.logs }
        
        let now = calendar.startOfDay(for: Date())
        
        guard let startDate = calendar.date(byAdding: daysBack.0, value: daysBack.1, to: now) else { return [] }

        let totals = totalsByDay(calendar: calendar)

        var results: [Log] = []
        results.reserveCapacity(365)

        var current = startDate
        while current <= now {
            if selectedPeriod == .week || selectedPeriod == .month {
                let day = calendar.startOfDay(for: current)
                results.append(Log(time: day, value: totals[day, default: 0]))
                current = calendar.date(byAdding: .day, value: 1, to: current)!
            } else {
                let t = totalValue(for: .year, on: current)
                results.append(Log(time: current, value: t))
                current = calendar.date(byAdding: .month, value: 1, to: current)!
            }
        }

        return results
    }
    
    func totalsByDay(calendar: Calendar = .current) -> [Date: Double] {
        var result: [Date: Double] = [:]

        for log in habit.logs {
            let day = calendar.startOfDay(for: log.time)
            result[day, default: 0] += log.value
        }

        return result
    }
    
    func totalValue(for component: Calendar.Component, on date: Date) -> Double {
        guard let interval = calendar.dateInterval(of: component, for: date) else {
            return 0
        }
        return totalValue(in: interval)
    }

    func totalValue(in interval: DateInterval) -> Double {
        let values = habit.logs
            .filter { interval.contains($0.time) }
            .map { $0.value }

        guard !values.isEmpty else { return 0 }

        if habit.name == "Weight" {
            return values.reduce(0, +) / Double(values.count)
        }

        return values.reduce(0, +)
    }
}

// Preview with sample data
#Preview {
    NavigationStack {
        VStack {
            HistoryChart(habit: Habit(sortOrder: 2, name: "name", icon: "figure", color: "orange", logs: [
                Log(time: Date().addingTimeInterval(-86400 * 30), value: 40),
                Log(time: Date().addingTimeInterval(-86400 * 29), value: 40),
                Log(time: Date().addingTimeInterval(-86400 * 22), value: 30),
                Log(time: Date().addingTimeInterval(-86400 * 20), value: 30),
                Log(time: Date().addingTimeInterval(-86400 * 14), value: 20),
                Log(time: Date().addingTimeInterval(-86400 * 12), value: 20),
                Log(time: Date().addingTimeInterval(-86400 * 10), value: 10),
                Log(time: Date().addingTimeInterval(-86400 * 8), value: 10),
                Log(time: Date().addingTimeInterval(-86400 * 6), value: 6),
                Log(time: Date().addingTimeInterval(-86400 * 4), value: 4),
                Log(time: Date().addingTimeInterval(-86400 * 2), value: 2),
                Log(time: Date(), value: 1)
            ]))
        }
//        .background(.orange)
    }
}
