//
//  ContentView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/22/26.
//

import SwiftUI
import CoreData

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
        .searchable(text: $dataController.filterText, tokens: $dataController.filterTokens, prompt: "Filter habits or type # to add tags") { tag in
            Text(tag.tagName)
        }
        .searchSuggestions {
            ForEach(dataController.suggestedFilterTokens) { tag in
                if !dataController.filterTokens.contains(tag) {
                    Button(tag.tagName) {
                        dataController.filterTokens.append(tag)
                        dataController.filterText = ""
                    }
                }
            }
        }
    }
    
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
