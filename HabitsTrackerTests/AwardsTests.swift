//
//  AwardsTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/5/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

final class AwardsTests: BaseTestCase {
	let awards = Award.allAwards

	func testAwardsIDsMatchNames() {
		for award in awards {
			XCTAssertEqual(award.id, award.name, "Award ID should match name")
		}
	}

	func testNewUsersHaveNoAwards() {
		for award in awards {
			XCTAssertFalse(dataController.hasEarned(award: award), "New users should not have any awards.")
		}
	}

	func testCreatingHabitsGivesUserAwards() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			var habits = [Habit]()

			for _ in 0..<value {
				let habit = Habit(context: managedObjectContext)
				habits.append(habit)
			}

			let matches = awards.filter { award in
				award.criterion == "habits" && dataController.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count + 1, "Adding \(value) habits should earn \(count + 1) awards.")
			dataController.deleteAll()
		}
	}

	func testCompletingHabitsGivesUserAwards() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			var habits = [Habit]()

			for _ in 0..<value {
				let habit = Habit(context: managedObjectContext)
				habit.completed = true
				habits.append(habit)
			}

			let matches = awards.filter { award in
				award.criterion == "closed" && dataController.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count + 1, "Completing \(value) habits should earn \(count + 1) awards.")
			dataController.deleteAll()
		}
	}

}
