//
//  SidebarView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/23/26.
//

import CoreData
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController

    var deferredBinding: Binding<Filter?> {
        Binding(
            get: { dataController.selectedFilter },
            set: { newValue in
                DispatchQueue.main.async {
                    dataController.selectedFilter = newValue
                }
            }
        )
    }

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>

    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""

	let smartFilters: [Filter] = [.all, .recent, .pastDue]

    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }

    var body: some View {
        List(selection: deferredBinding) {
            Section("Smart Filters") {
				ForEach(smartFilters) { filter in
					SmartFilterRow(filter: filter)
				}
            }

            Section("Tags") {
                ForEach(tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: rename, delete: delete)
                }
                .onDelete(perform: delete)
            }
        }
		.macFrame(minWidth: 230)
        .toolbar {
            SidebarViewToolbar()
        }
        .alert("Rename Tag", isPresented: $renamingTag) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $tagName)
        }
        .navigationTitle("Filters")
    }

	/// Deletes a set of tag filters via `.onDelete` modifier.
	/// - Parameter offsets: Set of Tag "Filter" to delete.
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let tag = tags[offset]
            dataController.delete(tag)
        }
    }

	/// Deletes a tag filter via Context Menu in ``UserFilterRow``.
	/// - Parameter filter: The Tag "Filter"  to delete.
    func delete(_ filter: Filter) {
        guard let tag = filter.tag else { return }

        dataController.delete(tag)
    }

	/// Sets up the rename via Context Menu in ``UserFilterRow``
	/// showing an alert.
	/// - Parameter filter: The Tag "Filter"  to rename.
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }

	/// Completes the renaming of a Tag "Filter" after the user
	/// presses "OK" in the saving alert.
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataController.preview)
}
