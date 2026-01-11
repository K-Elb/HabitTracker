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
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color.from(string: habit.color), Color.from(string: habit.color), .wb], startPoint: .top, endPoint: .bottom)
                .frame(height: 400)
                .ignoresSafeArea()
            
            VStack {
                HabitRow(habit: habit)
                    .padding()
                
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
        HabitDetail(habit: Habit(name: "drink water", icon: "drop.fill", color: "mint", frequency: .daily))
    }
}
