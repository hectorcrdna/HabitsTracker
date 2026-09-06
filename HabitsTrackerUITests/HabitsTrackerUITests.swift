//
//  HabitsTrackerUITests.swift
//  HabitsTrackerUITests
//
//  Created by Hector Cardona on 9/6/26.
//

import XCTest

extension XCUIElement {
	func clearText() {
		guard let stringValue = self.value as? String else {
			XCTFail("Failed to clear text in XCUIElement.")
			return
		}

		let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
		typeText(deleteString)
	}
}

final class HabitsTrackerUITests: XCTestCase {
	var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments = ["enable-testing"]
		app.launch()

    }

    @MainActor
    func testAppStartsWithNavigationBar() throws {

		XCTAssertTrue(
			app.navigationBars.element.exists,
			"There should be a navigation bar when the app launches."
		)
    }

	@MainActor
	func testAppHasBasicButtonsOnLaunch() throws {

		XCTAssertTrue(
			app.navigationBars.buttons["Filters"].exists,
			"There should be a Filters button when the app launches."
		)

		XCTAssertTrue(
			app.navigationBars.buttons["Filter"].exists,
			"There should be a Filter button when the app launches."
		)

		XCTAssertTrue(
			app.navigationBars.buttons["New Habit"].exists,
			"There should be a New Habit button when the app launches."
		)

	}

	@MainActor
	func testNoHabitsAtLaunch() throws {
		XCTAssertEqual(
			app.cells.count,
			0,
			"There should be no list rows when the app launches."
		)
	}

	@MainActor
	func testCreatingAndDeletingHabits() throws {
		for tapCount in 1...5 {
			app.buttons["New Habit"].tap()
			app.buttons["Habits"].tap()

			XCTAssertEqual(
				app.cells.count,
				tapCount,
				"There should be \(tapCount) list rows."
			)
		}

		for tapCount in (0...4).reversed() {
			app.cells.firstMatch.swipeLeft()
			app.buttons["Delete"].tap()

			XCTAssertEqual(
				app.cells.count,
				tapCount,
				"There should be \(tapCount) list rows."
			)
		}
	}

	@MainActor
	func testEditingHabitTitleUpdatesCorrectly() throws {

		XCTAssertEqual(
			app.cells.count,
			0,
			"There should be no list rows when the app launches."
		)

		app.buttons["New Habit"].tap()

		app.textFields["Enter the habit title here"].tap()
		app.textFields["Enter the habit title here"].clearText()
		app.typeText("My New Habit")
		app.buttons["Habits"].tap()

		XCTAssertTrue(
			app.buttons["My New Habit"].exists,
			"The new habit should be visible in the list."
		)
	}

	@MainActor
	func testEditingHabitPriorityUpdatesCorrectly() throws {
		app.buttons["New Habit"].tap()
		app.buttons["Priority, Medium"].tap()
		app.buttons["High"].tap()
		app.buttons["Habits"].tap()

		let identifier = "New habit High Priority"
		XCTAssertTrue(
			app.images[identifier].exists,
			"The new habit priority image should be visible in the list."
		)
	}

	@MainActor
	func testAllAwardsShowLockedAlert() throws {
		app.buttons["Filters"].tap()
		app.buttons["Show awards"].tap()

		for award in app.scrollViews.buttons.allElementsBoundByIndex {
			if app.windows.element.frame.contains(award.frame) == false {
				app.swipeUp()
			}

			award.tap()

			XCTAssertTrue(
				app.alerts["Locked"].exists,
				"This award should be locked."
			)

			app.buttons["OK"].tap()
		}
	}
}
