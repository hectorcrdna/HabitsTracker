//
//  ExtensionTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/5/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

final class ExtensionTests: BaseTestCase {
	func testHabitTitleUnwrapped() {
		let habit = Habit(context: managedObjectContext)

		habit.title = "My Habit"

		XCTAssertEqual(
			habit.habitTitle,
			"My Habit",
			"Changing title should also update habitTitle."
		)

		habit.habitTitle = "Updated Habit"

		XCTAssertEqual(
			habit.title,
			"Updated Habit",
			"Changing habitTitle should also update title."
		)

	}

	func testHabitContentUnwrapped() {
		let habit = Habit(context: managedObjectContext)

		habit.content = "My Habit"

		XCTAssertEqual(
			habit.habitContent,
			"My Habit",
			"Changing content should also update habitContent."
		)

		habit.habitContent = "Updated Habit"

		XCTAssertEqual(
			habit.content,
			"Updated Habit",
			"Changing habitContent should also update content."
		)

	}

	func testHabitCreationDateUnwrapped() {
		let habit = Habit(context: managedObjectContext)
		let date = Date.now

		habit.creationDate = date

		XCTAssertEqual(
			habit.habitCreationDate,
			date,
			"Changing creationDate should also update habitCreationDate."
		)
	}

	func testHabitTagsUnwrapped() {
		let habit = Habit(context: managedObjectContext)
		let tag = Tag(context: managedObjectContext)

		XCTAssertEqual(
			habit.habitTags.count,
			0,
			"A new habit should have no tags."
		)

		habit.addToTags(tag)

		XCTAssertEqual(
			habit.habitTags.count,
			1,
			"Adding a tag should add it to the habit's tags."
		)
	}

	func testHabitTagsList() {
		let habit = Habit(context: managedObjectContext)
		let tag = Tag(context: managedObjectContext)

		tag.name = "My Tag"
		habit.addToTags(tag)

		XCTAssertEqual(
			habit.habitTagsList,
			"My Tag",
			"Adding a tag should add it to the habit's tags list."
		)
	}

	func testHabitSortingIsStable() {
		let habit1 = Habit(context: managedObjectContext)
		habit1.title = "B habit"
		habit1.creationDate = Date.now

		let habit2 = Habit(context: managedObjectContext)
		habit2.title = "B habit"
		habit2.creationDate = Date.now.addingTimeInterval(50)

		let habit3 = Habit(context: managedObjectContext)
		habit3.title = "A habit"
		habit3.creationDate = Date.now.addingTimeInterval(100)

		let allHabits = [habit1, habit2, habit3]
		let sorted = allHabits.sorted()

		XCTAssertEqual(
			[habit3, habit1, habit2],
			sorted,
			"Habits should be sorted by title and then creation date."
		)

	}

	func testTagIdUnwrapped() {
		let tag = Tag(context: managedObjectContext)

		tag.id = UUID()

		XCTAssertEqual(
			tag.tagID,
			tag.id,
			"Changing id should also update tagId."
		)
	}

	func testTagNameUnwrapped() {
		let tag = Tag(context: managedObjectContext)
		let name = "My Tag"

		tag.name = name

		XCTAssertEqual(
			tag.tagName,
			name,
			"Changing name should also update tagName."
		)
	}

	func testTagActiveHabitsCount() {
		let tag = Tag(context: managedObjectContext)
		let habit = Habit(context: managedObjectContext)

		XCTAssertEqual(
			tag.tagActiveHabits.count,
			0,
			"There should be no active habits in a new tag."
		)

		tag.addToHabits(habit)

		XCTAssertEqual(
			tag.tagActiveHabits.count,
			1,
			"Once a habit is added, it should be counted as active."
		)

		habit.completed = true

		XCTAssertEqual(
			tag.tagActiveHabits.count,
			0,
			"Once a habit is marked as completed, it should no longer be counted as active."
		)

	}

	func testExampleTag() {
		let example = Tag.example

		XCTAssertEqual(
			example.name,
			"Example",
			"Example tag should have correct name"
		)
	}

	func testTagSortingIsStable() {
		let tag1 = Tag(context: managedObjectContext)
		tag1.name = "B tag"
		tag1.id = UUID()

		let tag2 = Tag(context: managedObjectContext)
		tag2.name = "B tag"
		tag2.id = UUID(uuidString: "FFFFFFFF-4A53-4BD0-8FD1-5051C2FA1C4D")

		let tag3 = Tag(context: managedObjectContext)
		tag3.name = "A tag"
		tag3.id = UUID()

		let allTags = [tag1, tag2, tag3]
		let sorted = allTags.sorted()

		XCTAssertEqual(
			[tag3, tag1, tag2],
			sorted,
			"tags should be sorted by name and then id."
		)
	}

	func testBundleDecodingAwards() {
		let awards = Bundle.main.decode("Awards.json", as: [Award].self)

		XCTAssertFalse(
			awards.isEmpty,
			"Should be able to decode awards from bundle."
		)
	}

	func testDecodingString() {
		let bundle = Bundle(for: ExtensionTests.self)
		let data = bundle.decode("DecodableString.json", as: String.self)

		XCTAssertEqual(
			data,
			"Never ask a starfish for directions.",
			"Should be able to decode string from bundle."
		)
	}

	func testDecodingDictionary() {
		let bundle = Bundle(for: ExtensionTests.self)
		let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)

		XCTAssertEqual(
			data,
			["One": 1, "Two": 2, "Three": 3],
			"Should be able to decode dictionary from bundle."
		)
	}
}
