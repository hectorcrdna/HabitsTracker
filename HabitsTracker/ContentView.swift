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
        .toolbar {
            Menu {
                Button(dataController.filterEnabled ? "Turn Filter off" : "Turn Filter on") {
                    dataController.filterEnabled.toggle()
                }
                
                Divider()
                
                Menu("Sort By") {
                    Picker("Sort By", selection: $dataController.sortType) {
                        Text("Date Created").tag(SortType.dateCreated)
                        Text("Date Modified").tag(SortType.dateModified)
                    }
                    
                    Divider()
                    
                    Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                        Text("Newest to Oldest").tag(true)
                        Text("Oldest to Newest").tag(false)
                    }
                }
                
                Picker("Status", selection: $dataController.filterStatus) {
                    Text("All").tag(Status.all)
                    Text("Open").tag(Status.open)
                    Text("Closed").tag(Status.closed)
                }
                .disabled(dataController.filterEnabled == false)
                
                Picker("Priority", selection: $dataController.filterPriority) {
                    Text("All").tag(-1)
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
                .disabled(dataController.filterEnabled == false)
                
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(dataController.filterEnabled ? .fill : .none)
            }
            
            Button(action: dataController.newHabit) {
                Label("New habit", systemImage: "square.and.pencil")
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
