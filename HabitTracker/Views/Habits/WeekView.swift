//
//  WeekView.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 12/01/2026.
//

import SwiftUI

struct WeekView: View {
    let habit: Habit
    let dates = WeekView.lastSevenDays()

    var body: some View {
        HStack {
            ForEach(dates, id: \.self) { date in
                VStack {
                    Text(shortDateFormatter.string(from: date))
                        .font(.caption.bold())
                        .foregroundStyle(.wb)
                    
                    let done: Bool = habit.totalOnThisDay(date) >= habit.dailyGoal
                    Circle()
                        .fill(done ? Color.from(string: habit.color) : .wb)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Text(dayFormatter.string(from: date))
                                .font(.headline)
                                .foregroundStyle(done ? .wb: Color.from(string: habit.color))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }

    // MARK: - Date Helpers

    static func lastSevenDays() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7)
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            .reversed()
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day number
        return formatter
    }

    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Mon, Tue, etc.
        return formatter
    }
}
