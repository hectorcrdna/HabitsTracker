//
//  ContentView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/22/26.
//

import CoreData
import StoreKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
	@Environment(\.requestReview) var requestReview

	private let newHabitActivity = "Cardona.Figueroa.Hector.HabitsTracker.NewHabit"

    var body: some View {
        List(selection: $dataController.selectedHabit) {
            ForEach(dataController.habitsForSelectedFilter()) { habit in
                HabitRow(habit: habit)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Habits")
        .searchable(
			text: $dataController.filterText,
			tokens: $dataController.filterTokens,
			prompt: "Filter habits or type # to add tags"
		) { tag in
            Text(tag.tagName)
        }
        .searchSuggestions {
            ForEach(dataController.suggestedFilterTokens) { tag in
                if dataController.filterTokens.contains(tag) == false {
                    Button(tag.tagName) {
                        dataController.filterTokens.append(tag)
                        dataController.filterText = ""
                    }
                }
            }
        }
        .toolbar {
            ContentViewToolbar()
        }
		.onAppear(perform: askForReview)
		.onOpenURL(perform: openURL)
		.userActivity(newHabitActivity) { activity in
			activity.isEligibleForPrediction = true
			activity.title = "New Habit"
		}
		.onContinueUserActivity(newHabitActivity, perform: resumeActivity)
    }

	/// Deletes a set of habits via `.onDelete` modifier.
	/// - Parameter offsets: Set of habits to delete.
    func delete(at offsets: IndexSet) {
        let habits = dataController.habitsForSelectedFilter()

        for offset in offsets {
            let habit = habits[offset]
            dataController.delete(habit)
        }
    }

	/// Performs the request for review if the user has made 5 or more tags.
	func askForReview() {
		if dataController.shouldRequestReview {
			requestReview()
		}
	}

	/// Creates a new habit when the user presses on the home screen application shortcut.
	/// - Parameter url: The URL used to identify the shortcut command.
	func openURL(_ url: URL) {
		if url.absoluteString.contains("NewHabit") {
			dataController.newHabit()
		}
	}

	func resumeActivity(_ activity: NSUserActivity) {
		dataController.newHabit()
	}
}

#Preview {
    ContentView()
}
