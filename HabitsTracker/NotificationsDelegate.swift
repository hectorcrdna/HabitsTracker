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

	override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self

	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void) {

			if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
				let userInfo = response.notification.request.content.userInfo

				if let habitId = userInfo["id"] as? String {

                    if let url = URL(string: habitId) {
                        DataController.shared.openURL(url)
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
                DataController.shared.objectWillChange.send()
			}
			completionHandler([.banner, .sound, .badge])
	}
}
