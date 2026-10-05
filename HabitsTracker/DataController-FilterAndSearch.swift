//
//  DataController-FilterAndSearch.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/30/26.
//

import CoreData
import Foundation

extension DataController {
	/// Filters out habits based on `SidebarView` filter selection, menu filter selection and search bar result.
	/// - Returns: An filtered array of habits.
	func habitsForSelectedFilter() -> [Habit] {
		let filter = selectedFilter ?? .all
		var predicates = [NSPredicate]()

		if let tag = filter.tag {
			let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
			predicates.append(tagPredicate)

		} else if filter == .pastDue {
			let enabledPredicate = NSPredicate(format: "reminderEnabled = %@", NSNumber(value: true))
			let pastDuePredicate = NSPredicate(format: "reminderDate < %@", Date.now as NSDate)
			let completedPredicate = NSPredicate(format: "completed = %@", NSNumber(value: false))

			let combinedPredicate = NSCompoundPredicate(
				andPredicateWithSubpredicates: [completedPredicate, pastDuePredicate, enabledPredicate]
			)
			predicates.append(combinedPredicate)

		} else {
			let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
			predicates.append(datePredicate)
		}

		// Gets the text from the search bar.
		let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

		if trimmedFilterText.isEmpty == false {
			let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
			let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)

			let combinedPredicate = NSCompoundPredicate(
				orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
			)

			predicates.append(combinedPredicate)
		}

		if filterTokens.isEmpty == false {
			let tokenPredicate = NSPredicate(format: "ANY tags in %@", filterTokens)
			predicates.append(tokenPredicate)
		}

		if filterEnabled {
			if filterPriority >= 0 {
				let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
				predicates.append(priorityFilter)
			}

			if filterStatus != .all {
				let lookForClosed = filterStatus == .closed
				let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
				predicates.append(statusFilter)
			}
		}

		let request = Habit.fetchRequest()
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

		let allHabits = results(for: request)
		return allHabits
	}
}
