//
//  PerformanceTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/6/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

final class PerformanceTests: BaseTestCase {
	func testAwardsCalculationPerformance() {
		for _ in 1...100 {
			dataController.createSampleData()
		}

		let awards = Array(repeating: Award.allAwards, count: 25).joined()

		XCTAssertEqual(
			awards.count,
			500,
			"This checks that the array of awards is built correctly, change if you add more awards."
		)

		measure {
			_ = awards.filter(dataController.hasEarned)
		}
	}
}
