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
                    DateButton(date)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func DateButton(_ date: Date) -> some View {
        let done: Bool = habit.totalOn(date) >= habit.dailyGoal
        VStack {
            Text(shortDateFormatter.string(from: date))
                .font(.caption.bold())
            
                    Text(dayFormatter.string(from: date))
        }
        .bold()
        .padding(8)
        .frame(maxWidth: .infinity)
        .foregroundStyle(done ? .wb: Color.from(string: habit.color))
        .background(selectedDate == date ? .primary : done ? Color.from(string: habit.color) : .wb)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
