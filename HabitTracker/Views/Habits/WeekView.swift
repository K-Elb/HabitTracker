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
                    let done = habit.completions.contains { $0.time.formatted(date: .abbreviated, time: .omitted) == date.formatted(date: .abbreviated, time: .omitted) }
                    Circle()
                        .fill(done ? .clear : .wb)
                        .frame(width: UIScreen.main.bounds.width/10)
                        .overlay(
                            Text(dayFormatter.string(from: date))
                                .font(.headline)
                                .foregroundStyle(done ? .wb: .accent)
                        )

                    Text(shortDateFormatter.string(from: date))
                        .font(.caption.bold())
                        .foregroundColor(.wb)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Color.from(string: habit.color))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(.horizontal)
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
