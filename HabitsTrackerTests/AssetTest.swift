//
//  AssetTest.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/3/26.
//

import XCTest
@testable import HabitsTracker

final class AssetTest: XCTestCase {
	func testColorsExist() {
		let allColors = [ColorResource(name: "My Gold", bundle: .main), ColorResource(name: "My Green", bundle: .main),
						 ColorResource(name: "My Light Blue", bundle: .main), ColorResource(name: "My Purple", bundle: .main)]

		for color in allColors {
			XCTAssertNotNil(UIColor(resource: color), "Failed to load color '\(color)' from asset catalog.")
		}
	}

	func testAwardsLoadCorrectly() {
		XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
	}
}
