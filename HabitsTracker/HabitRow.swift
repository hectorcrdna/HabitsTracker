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
                    
                    Text("No tags.")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(habit.habitCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    
                    if habit.completed {
                        Text("Completed")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HabitRow(habit: .example)
}
