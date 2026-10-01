//
//  CompleteIncompleteButtonView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/30/26.
//

import SwiftUI

struct CompleteIncompleteButtonView: View {
	@EnvironmentObject var dataController: DataController
	@ObservedObject var habit: Habit

	var openCloseHabitButtonTitle: LocalizedStringKey {
		habit.completed ? "Mark Incomplete" : "Mark Completed"
	}

    var body: some View {
		Button {
			habit.completed.toggle()
			dataController.save()
		} label: {
			Label(openCloseHabitButtonTitle, systemImage: "bubble.left.and.exclamationmark.bubble.right")
		}
    }
}

#Preview {
	CompleteIncompleteButtonView(habit: .example)
}
