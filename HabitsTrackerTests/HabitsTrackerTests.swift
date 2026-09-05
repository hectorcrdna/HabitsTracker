//
//  HabitsTrackerTests.swift
//  HabitsTrackerTests
//
//  Created by Hector Cardona on 9/3/26.
//

import CoreData
import XCTest
@testable import HabitsTracker

class BaseTestCase: XCTestCase {
	var dataController: DataController!
	var managedObjectContext: NSManagedObjectContext!

	override func setUpWithError() throws {
		dataController = DataController(inMemory: true)
		managedObjectContext = dataController.container.viewContext
	}
}
