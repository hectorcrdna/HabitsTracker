//
//  DevelopmentTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/5/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

final class DevelopmentTests: BaseTestCase {
	func testSampleDataCreationWorks() {
		dataController.createSampleData()

		XCTAssertEqual(
			dataController.count(for: Tag.fetchRequest()),
			5,
			"There should be 5 sample tags."
		)

		XCTAssertEqual(
			dataController.count(for: Habit.fetchRequest()),
			50,
			"There should be 50 sample Habits."
		)
	}

	func testDeletingAllDataWorks() {
		dataController.createSampleData()
		dataController.deleteAll()

		XCTAssertEqual(
			dataController.count(for: Tag.fetchRequest()),
			0,
			"There should be no tags after deleteAll()."
		)

		XCTAssertEqual(
			dataController.count(for: Habit.fetchRequest()),
			0,
			"There should be no habits after deleteAll()."
		)
	}

	func testSampleTagHasNoHabits() {
		let tag = Tag.example

		XCTAssertEqual(
			tag.habits?.count,
			0,
			"There should be no habits in the example tag."
		)
	}

	func testSampleHabitPriorityIsHigh() {
		let habit = Habit.example

		XCTAssertEqual(
			habit.priority,
			2,
			"priority should be High '2'."
		)
	}
}
