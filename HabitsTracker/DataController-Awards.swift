//
//  DataController-Awards.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/25/26.
//

import Foundation
import CoreData

extension DataController {
	/// Returns true if the user has earned the award.
	/// - Parameter award: The award to query.
	/// - Returns: A Bool indicating if the award has been earned.
	func hasEarned(award: Award) -> Bool {
		switch award.criterion {
		case "habits":
			let fetchRequest = Habit.fetchRequest()
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value

		case "closed":
			let fetchRequest = Habit.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "completed = true")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value

		case "tags":
			let fetchRequest = Tag.fetchRequest()
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value

		case "unlock":
			return fullVersionUnlocked

		default:
			fatalError("Unknown award criterion \(award.criterion)")
		}
	}

}
