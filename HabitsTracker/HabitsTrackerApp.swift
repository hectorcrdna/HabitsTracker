//
//  HabitsTrackerApp.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/22/26.
//

import SwiftUI
import CoreData
import CoreSpotlight

@main
struct HabitsTrackerApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)

			// If the user leaves the app while editing the changes are saved.
            .onChange(of: scenePhase) { _, newValue in
                if newValue != .active {
                    dataController.save()
                }
            }

			// If the user uses Spotlight to search for a Habit's title or content and
			// there is a match, the user can then tap the item and the app will launch
			// and load the Habit on to the screen.
			.onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
        }
    }

	/// Loads the Habit selected in Spotlight search.
	/// - Parameter userActivity: The NSUserActivity sent to us by Spotlight.
	func loadSpotlightItem(_ userActivity: NSUserActivity) {
		if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
			dataController.selectedHabit = dataController.habit(with: identifier)
			dataController.selectedFilter = .all
		}
	}
}
