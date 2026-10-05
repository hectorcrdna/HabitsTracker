//
//  SidebarViewToolbar.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/31/26.
//

import SwiftUI

struct SidebarViewToolbar: ToolbarContent {
    @EnvironmentObject var dataController: DataController
	@State private var showingStore = false

    @State private var showingAwards = false

    var body: some ToolbarContent {
		ToolbarItem(placement: .automaticOrTrailing) {
			Button(action: tryNewTag) {
				Label("Add tag", systemImage: "plus")
			}
			.sheet(isPresented: $showingStore) {
				StoreView()
			}
			.help("Add tag")
		}

		ToolbarItem(placement: .automaticOrLeading) {
			Button {
				showingAwards.toggle()
			} label: {
				Label("Show awards", systemImage: "rosette")
			}
			.help("Show awards")
			.sheet(isPresented: $showingAwards) {
				AwardsView()
			}
		}

		#if DEBUG
		ToolbarItem(placement: .automatic) {
			Button {
				dataController.deleteAll()
				dataController.createSampleData()
			} label: {
				Label("Add Samples", systemImage: "flame")
			}
		}
		#endif
    }

	func tryNewTag() {
		if dataController.newTag() == false {
			showingStore = true
		}
	}
}
