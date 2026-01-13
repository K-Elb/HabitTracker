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

struct YearTaskGridView: View {
    let year: Int
    let completedDates: Set<Date>
    let color: Color

    private let calendar = Calendar.current
    private let circleSize: CGFloat = 10
    private let spacing: CGFloat = 0

    var body: some View {
        VStack {
            HStack(spacing: (UIScreen.main.bounds.width)/18) {
                Text("J")
                Text("F")
                Text("M")
                Text("A")
                Text("M")
                Text("J")
                Text("J")
                Text("A")
                Text("S")
                Text("O")
                Text("N")
                Text("D")
            }
//            .frame(width: UIScreen.main.bounds.width*0.75)
            .offset(y: 12)
            .font(.caption.bold())
            .foregroundStyle(.gray)
            
            Chart(allDaysInYear, id: \.date) { date in
                let w  = MarkDimension(floatLiteral: 16)
                if date.value != 0 {
                    RectangleMark (
                        x: .value("x", date.x),
                        y: .value("y", date.y),
                        width: w,
                        height: w
                    )
                    .cornerRadius(16)
                    .foregroundStyle(by: .value("Number", date.value))
                } else {
                    RectangleMark (
                        x: .value("x", date.x),
                        y: .value("y", date.y),
                        width: w,
                        height: w
                    )
                    .cornerRadius(16)
                    .foregroundStyle(.gray.opacity(0.25))
                }
            }
            //            .frame(width: UIScreen.main.bounds.width * 0.7, height: (UIScreen.main.bounds.width * 0.7) * 0.7)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-160)
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(domain: 0...13)
            .chartYScale(domain: -32...0)
            .chartForegroundStyleScale(range: [color.opacity(0.2), color.opacity(0.6), color])
        }
    }

    // MARK: - Helpers

    private var allDaysInYear: [TaskCompletion] {
        guard
            let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
            let end = calendar.date(from: DateComponents(year: year, month: 12, day: 31))
        else { return [] }

        var dates: [TaskCompletion] = []
        var current = start
        let calendar = Calendar.current
        
        while current <= end {
            dates.append(TaskCompletion(
                date: current,
                x: calendar.component(.month, from: current),
                y: -calendar.component(.day, from: current),
                value: Double(Int.random(in: 0...3))))
            
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }

    private func isCompleted(_ date: Date) -> Bool {
        completedDates.contains {
            calendar.isDate($0, inSameDayAs: date)
        }
    }
}

struct YearView: View {
    let color: Color
    
    var body: some View {
        YearTaskGridView(
            year: 2026,
            completedDates: sampleCompletedDates,
            color: color
        )
    }

    private var sampleCompletedDates: Set<Date> {
        let calendar = Calendar.current
        return Set((1...100).compactMap {
            calendar.date(byAdding: .day, value: $0, to: Date())
        })
    }
}

#Preview {
    YearView(color: .red)
}
