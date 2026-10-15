//
//  VisionSensoryFeedback.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/28/26.
//

import SwiftUI

extension View {
    func visionSensoryFeedback(trigger: Bool) -> some View {
		if #available(visionOS 26, *, iOS 17, *, macOS 14, *) {
            return self.sensoryFeedback(trigger: trigger) {
                trigger ? .success : nil
            }
		}
        return self
	}
}
