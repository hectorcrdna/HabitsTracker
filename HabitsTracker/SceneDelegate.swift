//
//  SceneDelegate.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/24/26.
//

import SwiftUI

/// A Delegate that takes care of opening the url that comes from the home screen shortcut item.
class SceneDelegate: NSObject, UIWindowSceneDelegate {
	@MainActor
	func windowScene(
		_ windowScene: UIWindowScene,
		performActionFor shortcutItem: UIApplicationShortcutItem,
		completionHandler: @escaping (Bool) -> Void
	) {
		guard let url = URL(string: shortcutItem.type) else {
			completionHandler(false)
			return
		}

		windowScene.open(url, options: nil, completionHandler: completionHandler)
	}

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		if let shortCutItem = connectionOptions.shortcutItem {
			if let url = URL(string: shortCutItem.type) {
				scene.open(url, options: nil)
			}
		}
	}
}
