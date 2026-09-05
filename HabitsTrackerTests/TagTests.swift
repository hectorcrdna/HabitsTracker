//
//  TagTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/5/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

final class TagTests: BaseTestCase {
	func testCreatingTagsAndHabits() {
		let targetCount = 10

		for _ in 0..<targetCount {
			let tag = Tag(context: managedObjectContext)

			for _ in 0..<targetCount {
				let habit = Habit(context: managedObjectContext)
				tag.addToHabits(habit)
			}
		}

		XCTAssertEqual(
			dataController.count(for: Tag.fetchRequest()),
			targetCount,
			"There should be \(targetCount) tags."
		)

		XCTAssertEqual(
			dataController.count(for: Habit.fetchRequest()),
			targetCount * targetCount,
			"There should be \(targetCount * targetCount) habits."
		)

	}

	func testDeletingTagDoesNotDeleteHabits() throws {
		dataController.createSampleData()

		let request = NSFetchRequest<Tag>(entityName: "Tag")
		let tags = try managedObjectContext.fetch(request)

		dataController.delete(tags[0])

		XCTAssertEqual(
			dataController.count(for: Tag.fetchRequest()),
			4,
			"There should be 4 tags after deleting one from sample data."
		)

		XCTAssertEqual(
			dataController.count(for: Habit.fetchRequest()),
			50,
			"There should still be 50 Habits after deleting one tag from sample data."
		)

	}
}
