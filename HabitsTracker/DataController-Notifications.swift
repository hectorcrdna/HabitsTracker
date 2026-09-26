//
//  DataController-Notifications.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/18/26.
//

import CoreData
import Foundation
import UserNotifications

extension DataController {
	/// Adds a notification iff allowed by the user.
	///
	/// If the user has never added a reminder the app will request permission to send notifications.
	/// - Parameter habit: The habit associated with the notification.
	/// - Returns: Returns `true` if the reminder can be placed,
	/// otherwise returns `false`.
	func addReminder(for habit: Habit) async -> Bool {
		do {
			let center = UNUserNotificationCenter.current()
			let settings = await center.notificationSettings()

			switch settings.authorizationStatus {
			case .notDetermined:
				let success = try await requestNotification()

				if success {
					try await placeReminders(for: habit)
				} else {
					return false
				}

			case .authorized:
				try await placeReminders(for: habit)

			default:
				return false
			}

			return true
		} catch {
			return false
		}
	}

	/// Removes any pending notifications for a specified habit.
	/// - Parameter habit: The habit associated with the notification.
	func removeReminders(for habit: Habit) {
		let center = UNUserNotificationCenter.current()
		let id = habit.objectID.uriRepresentation().absoluteString
		center.removePendingNotificationRequests(withIdentifiers: [id])
	}

	/// Removes a delivered notification from the badge count.
	/// - Parameter habit: The habit associated with the notification
	func removeFromBadgeCount(_ habit: Habit) async {
		let center = UNUserNotificationCenter.current()
		let id = habit.objectID.uriRepresentation().absoluteString
		center.removeDeliveredNotifications(withIdentifiers: [id])
		try? await center.setBadgeCount(center.deliveredNotifications().count)
	}

	/// Requests permission to send the user "alerts, badge and sounds" notifications.
	/// - Returns: `true` if authorized by the user, otherwise `false`.
	private func requestNotification() async throws -> Bool {
		let center = UNUserNotificationCenter.current()
		return try await center.requestAuthorization(options: [.alert, .badge, .sound])
	}

	/// Sends a notification to remind the user of a specific habit at a date and time specified by the user.
	/// - Parameter habit: The habit to remind the user of.
	private func placeReminders(for habit: Habit) async throws {
		let center = UNUserNotificationCenter.current()

		let content = UNMutableNotificationContent()
		content.title = habit.habitTitle
		content.sound = .default
		content.badge = await (center.deliveredNotifications().count + 1) as NSNumber

		if let habitContent = habit.content {
			content.subtitle = habitContent
		}

		let dateComponents = notificationFrequency(for: habit)

		let trigger = UNCalendarNotificationTrigger(
			dateMatching: dateComponents,
			repeats: habit.notificationFrequency != Frequency.none.rawValue
		)

		let id = habit.objectID.uriRepresentation().absoluteString
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

		return try await center.add(request)
	}

	/// Chooses the right date components from the time, date and frequency the user wants to be reminded of a habit.
	/// - Parameter habit: The habit to remind the user of.
	/// - Returns: `DateComponents` for the use of a notification request.
	private func notificationFrequency(for habit: Habit) -> DateComponents {
		let calendar = Calendar.current

		switch habit.notificationFrequency {
		case Frequency.weekly.rawValue:
			return calendar.dateComponents([.weekday, .hour, .minute], from: habit.habitReminderDate)

		case Frequency.monthly.rawValue:
			return calendar.dateComponents([.day, .hour, .minute], from: habit.habitReminderDate)

		case Frequency.yearly.rawValue:
			return calendar.dateComponents([.month, .day, .hour, .minute], from: habit.habitReminderDate)

		default:
			return calendar.dateComponents([.hour, .minute], from: habit.habitReminderDate)
		}
	}
}
