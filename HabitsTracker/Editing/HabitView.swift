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

	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = calendar.dateComponents([.year], from: .now)
		let endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: .distantFuture)
		return calendar.date(from: startComponents)!
			...
			calendar.date(from: endComponents)!
	}()

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
						.labelsHidden()

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
					.labelsHidden()

                }
            }

			Section("Reminders") {
				Toggle("Show reminders", isOn: $habit.reminderEnabled.animation())

				if habit.reminderEnabled {
					DatePicker("Reminder date",
							   selection: $habit.habitReminderDate,
							   in: dateRange,
							   displayedComponents: .date
					)
					DatePicker("Reminder time",
							   selection: $habit.habitReminderDate,
							   in: dateRange,
							   displayedComponents: .hourAndMinute
					)

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
		.formStyle(.grouped)
        .disabled(habit.isDeleted)
        .onReceive(habit.objectWillChange) {
            dataController.save()
        }
        .onSubmit(dataController.save)
        .toolbar {
            HabitViewToolbar(habit: habit)
        }
		.alert("Oops!", isPresented: $showingNotificationError) {
			#if os(macOS)
			SettingsLink {
				Text("Check Settings")
			}
			#elseif os(iOS)
			Button("Check Settings", action: showAppSettings)
			#endif
			Button("Cancel", role: .cancel) {}
		} message: {
			Text("There was a problem setting your notification. Please check you have notifications enabled.")
		}
		.onChange(of: habit.completed) { _, newValue in
			if newValue {
				if habit.notificationFrequency != Frequency.none.rawValue {
					if let idString = habit.successorID?.absoluteString {
						if dataController.habit(with: idString) != nil {
							return updateReminder(for: habit)
						}
					}
					return updateReminder(for: dataController.copy(habit))
				}
			}
			updateReminder(for: habit)
		}
		.onChange(of: habit.reminderEnabled) { _, newValue in
			if newValue == false {
				habit.reminderDate = nil
			}
			updateReminder(for: habit)
		}
		.onChange(of: habit.habitReminderDate) {
			updateReminder(for: habit)
		}
		.onChange(of: habit.notificationFrequency) {
			updateReminder(for: habit)
		}
	}

	#if os(iOS)
	/// Opens the Settings app.
	func showAppSettings() {
		guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
		openURL(settingsURL)
	}
	#endif

	/// Acts on the selection of the reminders toggle to add a reminder when turned on.
	func updateReminder(for habit: Habit) {
		Task {
			let (addNotification, removeBadge) = await dataController.updateNotifications(for: habit)
			if (addNotification, removeBadge) == (false, false) {
				habit.reminderEnabled = false
				showingNotificationError = true
			}
		}
	}
}

#Preview {
    HabitView(habit: .example)
}
