//
//  ContentView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/22/26.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        List(selection: $dataController.selectedHabit) {
            ForEach(dataController.habitsForSelectedFilter()) { habit in
                HabitRow(habit: habit)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Habits")
        .searchable(
			text: $dataController.filterText,
			tokens: $dataController.filterTokens,
			prompt: "Filter habits or type # to add tags"
		) { tag in
            Text(tag.tagName)
        }
        .searchSuggestions {
            ForEach(dataController.suggestedFilterTokens) { tag in
                if dataController.filterTokens.contains(tag) == false {
                    Button(tag.tagName) {
                        dataController.filterTokens.append(tag)
                        dataController.filterText = ""
                    }
                }
            }
        }
        .toolbar {
            ContentViewToolbar()
        }
    }

	/// Deletes a set of habits via `.onDelete` modifier.
	/// - Parameter offsets: Set of habits to delete.
    func delete(at offsets: IndexSet) {
        let habits = dataController.habitsForSelectedFilter()

        for offset in offsets {
            let habit = habits[offset]
            dataController.delete(habit)
        }
    }
}

#Preview {
    ContentView()
}
