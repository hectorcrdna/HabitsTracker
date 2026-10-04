//
//  HabitRowWatch.swift
//  TrackerWatch Watch App
//
//  Created by Hector Cardona on 9/28/26.
//

import SwiftUI

struct HabitRowWatch: View {
	@EnvironmentObject var dataController: DataController
	@ObservedObject var habit: Habit

    var body: some View {
		NavigationLink(value: habit) {
			VStack(alignment: .leading) {
				Text(habit.habitTitle)
					.font(.headline)
					.lineLimit(1)
					.foregroundStyle(habit.habitReminderDate < Date.now ? .red : .primary)

				Text(habit.habitCreationDate.formatted(date: .numeric, time: .omitted))
					.font(.subheadline)

			}
			.foregroundStyle(habit.completed ? .secondary : .primary)
		}
    }
}

#Preview {
	HabitRowWatch(habit: .example)
}
