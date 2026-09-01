//
//  HabitsTrackerApp.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/22/26.
//

import SwiftUI
import CoreData

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
            .onChange(of: scenePhase) { _, newValue in
                if newValue != .active {
                    dataController.save()
                }
            }
        }
    }
}
