//
//  AppDelegate.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/24/26.
//

import SwiftUI

/// The UIKit Application Delegate that takes care of assigning the ``SceneDelegate`` as delegate to handle opening
/// the url's that come from the home screen shortcuts.
class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
		sceneConfiguration.delegateClass = SceneDelegate.self
		return sceneConfiguration
	}
}
