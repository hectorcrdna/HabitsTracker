//
//  SmartFilterRow.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/31/26.
//

import SwiftUI

struct SmartFilterRow: View {
	@EnvironmentObject var dataController: DataController

	var pastDueAndIncompleteCount: Int {
		let request = Habit.fetchRequest()
		return dataController.results(for: request).filter {
			guard $0.reminderEnabled else { return false }
			guard let date = $0.reminderDate else { return false }
			return $0.completed == false && date < Date.now
		}.count
	}

    var filter: Filter

	var body: some View {
		if pastDueAndIncompleteCount != 0 || filter != .pastDue {
			NavigationLink(value: filter) {
				Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
					.numberBadge(filter == .pastDue ? pastDueAndIncompleteCount : 0)
			}
		}
	}
}

#Preview {
    SmartFilterRow(filter: .all)
}
