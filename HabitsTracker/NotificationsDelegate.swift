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
	let dataController: DataController!

	init(controller: DataController) {
		self.dataController = controller
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void) {

			if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
				let userInfo = response.notification.request.content.userInfo

				if let habitId = userInfo["id"] as? String {

                    if let url = URL(string: habitId) {
                        dataController.openURL(url)
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
				self.dataController.objectWillChange.send()
			}
			completionHandler([.banner, .sound, .badge])
	}
}
