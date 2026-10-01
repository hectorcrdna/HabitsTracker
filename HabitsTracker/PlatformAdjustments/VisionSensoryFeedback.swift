//
//  VisionSensoryFeedback.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/28/26.
//

import SwiftUI

extension View {
	@ViewBuilder
	func visionSensoryFeedback(trigger: Bool) -> some View {
		if #unavailable(visionOS 2.0) {
			self.sensoryFeedback(trigger: trigger) { _, newValue in
				if newValue {
					return .success
				} else {
					return nil
				}
			}
		} else {
			self
		}
	}
}
