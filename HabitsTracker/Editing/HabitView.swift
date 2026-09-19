//
//  HabitView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/27/26.
//

import CoreData
import SwiftUI

struct HabitView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

	// Will show an alert telling the user the app is not authorized to send notifications.
	@State private var showingNotificationError = false

	// opens a URL to the notifications settings.
	@Environment(\.openURL) var openURL

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
					TextField("Title", text: $habit.habitTitle, prompt: Text("Enter the habit title here"))
                        .font(.title)

                    Text("**Modified:** \(habit.habitModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)

                    HStack {
						Text("**Status:** \(habit.habitStatus)")
                            .foregroundStyle(.secondary)
                    }
                }

                Picker("Priority", selection: $habit.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }

                TagsMenuView(habit: habit)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField(
						"Description",
						text: $habit.habitContent,
						prompt: Text("Enter the habit description here"),
						axis: .vertical
					)

                }
            }

			Section("Reminders") {
				Toggle("Show reminders", isOn: $habit.reminderEnabled.animation())

				if habit.reminderEnabled {
					DatePicker("Reminder date", selection: $habit.habitReminderDate)

					Picker("Repeat", selection: $habit.notificationFrequency) {
						Text("Never").tag(Frequency.none.rawValue)
						Text("Daily").tag(Frequency.daily.rawValue)
						Text("Weekly").tag(Frequency.weekly.rawValue)
						Text("Monthly").tag(Frequency.monthly.rawValue)
						Text("Yearly").tag(Frequency.yearly.rawValue)
					}
				}
			}
        }
        .disabled(habit.isDeleted)
        .onReceive(habit.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            HabitViewToolbar(habit: habit)
        }
		.alert("Oops!", isPresented: $showingNotificationError) {
			Button("Check Settings", action: showAppSettings)
			Button("Cancel", role: .cancel) {}
		} message: {
			Text("There was a problem setting your notification. Please check you have notifications enabled.")
		}
		.onChange(of: habit.reminderEnabled) { _, _ in
			updateReminder()
		}
		.onChange(of: habit.reminderDate) { _, _ in
			updateReminder()
		}
		.onChange(of: habit.notificationFrequency) { _, _ in
			updateReminder()
		}
}

	/// Opens the Settings app.
	func showAppSettings() {
		guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
		openURL(settingsURL)
	}

	/// Acts on the selection of the reminders toggle to add a reminder when turned on.
	func updateReminder() {
		// Removes any reminders in the system so there are no multiple reminders.
		dataController.removeReminders(for: habit)

		Task { @MainActor in
			if habit.reminderEnabled {
				// Tries to set the reminder if it cant lets the user know.
				let success = await dataController.addReminder(for: habit)

				if success == false {
					habit.reminderEnabled = false
					showingNotificationError = true
				}
			} else {
				// Once the reminder is turned off we remove it from the badge count.
				await dataController.removeFromBadgeCount(habit)
			}
		}
	}
}

#Preview {
    HabitView(habit: .example)
}
