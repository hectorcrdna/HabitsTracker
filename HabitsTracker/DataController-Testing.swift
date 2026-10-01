//
//  DataController-Testing.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/29/26.
//

import SwiftUI

extension DataController {
	func checkForTestEnvironment() {
		// If we're running test in Debug we delete all data to start
		// with a clean slate every time we launch and disabled
		// animations to make UI Test faster.
		#if DEBUG
		if CommandLine.arguments.contains("enable-testing") {
			self.deleteAll()
			#if os(iOS)
			UIView.setAnimationsEnabled(false)
			#endif
		}
		#endif
	}
}
