//
//  HabitDetail.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI

struct HabitDetail: View {
    let habit: Habit
    var isDetailed: Bool = true
    
    var body: some View {
        ScrollView {
            VStack {
                HabitRow(habit: habit)
                
                if isDetailed {
                    WeekView(habit: habit)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HabitDetail(habit: Habit(name: "drink water", icon: "drop.fill", color: "mint"))
    }
}
