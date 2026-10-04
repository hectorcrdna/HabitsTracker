//
//  SmartFilterRow.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/31/26.
//

import SwiftUI

struct SmartFilterRow: View {
	@EnvironmentObject var dataController: DataController

	var pastDueHabitsCount: Int {
		let request = Habit.fetchRequest()
		return dataController.results(for: request).filter {
			$0.reminderEnabled && $0.habitReminderDate < Date.now
		}.count
	}

    var filter: Filter

	var body: some View {
		if pastDueHabitsCount != 0 || filter != .pastDue {
			NavigationLink(value: filter) {
				Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
					.numberBadge(filter == .pastDue ? pastDueHabitsCount : 0)
			}
		}
	}
}

#Preview {
    SmartFilterRow(filter: .all)
}
