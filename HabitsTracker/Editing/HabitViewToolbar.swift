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
            Button("Copy Habit Title", systemImage: "doc.on.doc", action: copyToClipboard)

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

	func copyToClipboard() {
		#if os(iOS)
		UIPasteboard.general.string = habit.title
		#else
		NSPasteboard.general.prepareForNewContents()
		NSPasteboard.general.setString(habit.habitTitle, forType: .string)
		#endif
	}
}

#Preview {
    HabitViewToolbar(habit: Habit.example)
        .environmentObject(DataController(inMemory: true))
}
