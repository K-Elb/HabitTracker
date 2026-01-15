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
    
    @Binding var selectedDate: Date

    var body: some View {
        HStack(spacing: 8) {
            ForEach(dates, id: \.self) { date in
                Button(action: { selectDate(date) }) {
                    VStack(spacing: 0) {
                        Text(shortDateFormatter.string(from: date))
                            .font(.caption.bold())
                            .foregroundStyle(selectedDate == date ? .accent : .wb)
                        
                        let done: Bool = habit.totalOnThisDay(date) >= habit.dailyGoal
                        RoundedRectangle(cornerRadius: 32)
                            .fill(selectedDate == date ? .primary : done ? Color.from(string: habit.color) : .wb)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Text(dayFormatter.string(from: date))
                                    .bold()
                                    .foregroundStyle(done ? .wb: Color.from(string: habit.color))
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Date Helpers
    
    func selectDate(_ date: Date) {
        if selectedDate == date {
            selectedDate = Date()
        } else {
            selectedDate = date
        }
    }

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
