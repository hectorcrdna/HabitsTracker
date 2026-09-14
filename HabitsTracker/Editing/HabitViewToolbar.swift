//
//  HabitViewToolbar.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/31/26.
//

import SwiftUI

struct HabitViewToolbar: View {
    @EnvironmentObject var dataController: DataController
	@ObservedObject var habit: Habit

	var openCloseHabitButtonTitle: LocalizedStringKey {
		habit.completed ? "Mark Incomplete" : "Mark Completed"
	}

    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = habit.title
            } label: {
                Label("Copy Habit Title", systemImage: "doc.on.doc")
            }

            Button {
                habit.completed.toggle()
                dataController.save()
            } label: {
                Label(openCloseHabitButtonTitle, systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
			.sensoryFeedback(trigger: habit.completed) { _, newValue in
				if newValue {
					return .success
				} else {
					return nil
				}
			}

            Divider()

            Section("Tags") {
                TagsMenuView(habit: habit)
            }

        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
}

#Preview {
    HabitViewToolbar(habit: Habit.example)
        .environmentObject(DataController(inMemory: true))
}
