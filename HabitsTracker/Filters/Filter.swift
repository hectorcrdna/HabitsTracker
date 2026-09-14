//
//  Filter.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/23/26.
//

import Foundation

/// A type to be shown as a list rows in ``SidebarView``.
struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?

    var activeHabitsCount: Int {
        tag?.tagActiveHabits.count ?? 0
    }

	// The two static properties are made to act as "Smart Filters" in `SidebarView`,
	// all other filters are generated in `SidebarView` as `tagFilters`.
    static var all = Filter(
		id: UUID(),
		name: "All Habits",
		icon: "tray"
	)

    static var recent = Filter(
		id: UUID(),
		name: "Recent Habits",
		icon: "clock",
		minModificationDate: .now.addingTimeInterval(86400 * -7)
	)

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
