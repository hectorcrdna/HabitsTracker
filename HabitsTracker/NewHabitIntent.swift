//
//  NewHabitIntent.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 10/16/26.
//

import AppIntents
import SwiftUI

struct NewHabitIntent: AppIntent {
    static let title: LocalizedStringResource = "Create New Habit"

    @MainActor
    func perform() async throws -> some IntentResult {
        DataController.shared.newHabit()
        DataController.shared.selectedFilter = .all

        return .result()
    }

    static var openAppWhenRun: Bool = true
}
