//
//  PastDueForegroundStyle.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 10/4/26.
//

import SwiftUI

extension View {
	func pastDueForegroundStyle(for habit: Habit) -> some View {

		guard habit.completed == false else { return self.foregroundStyle(.secondary as Color)}
		guard let date = habit.reminderDate, date < Date.now else { return self.foregroundStyle(.primary as Color)}

		return self.foregroundStyle(.red)
	}
}
