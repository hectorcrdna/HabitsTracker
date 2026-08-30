//
//  HabitRow.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/26/26.
//

import SwiftUI

struct HabitRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit
    
    var body: some View {
        NavigationLink(value: habit) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(habit.priority == 2 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Text(habit.habitTitle)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(habit.habitTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(habit.habitCreationDate.formatted(date: .numeric, time: .omitted))
                        .accessibilityLabel(habit.habitCreationDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                    
                    if habit.completed {
                        Text("Completed")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityHint(habit.priority == 2 ? "Hi priority" : "")
    }
}

#Preview {
    HabitRow(habit: .example)
}
