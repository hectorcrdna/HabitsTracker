//
//  NotificationsDelegate.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 10/1/26.
//

import Combine
import SwiftUI
import UserNotifications

class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
	let controller: DataController!

	init(controller: DataController!) {
		self.controller = controller
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void) {

			if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
				let userInfo = response.notification.request.content.userInfo

				if let habitId = userInfo["id"] as? String {

					if let url = URL(string: habitId) {
						controller.openURL(url)
					}
				}
			}

			completionHandler()
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

			DispatchQueue.main.async {
				self.controller.objectWillChange.send()
			}
			completionHandler([.banner, .sound, .badge])
	}
}
