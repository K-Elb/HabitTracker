//
//  HabitDetail.swift
//  HabitTracker
//
//  Created by Karim Elbehiri on 11/01/2026.
//

import SwiftUI

struct HabitDetail: View {
    @Environment(\.dismiss) var dismiss
    let habit: Habit
    
    var body: some View {
        ScrollView {
            VStack {
                HabitRow(habit: habit, height: 120)
                
                ScrollView {
                    VStack {
                        Text(habit.name)
                    }
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
