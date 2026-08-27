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
    
    var habits: [Habit] {
        let filter = dataController.selectedFilter ?? .all
        var allHabits: [Habit]
        
        if let tag = filter.tag {
            allHabits = tag.habits?.allObjects as? [Habit] ?? []
        } else {
            let request = Habit.fetchRequest()
            request.predicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            allHabits = (try? dataController.container.viewContext.fetch(request)) ?? []
        }
        
        return allHabits.sorted()
    }
    
    var body: some View {
        List(selection: $dataController.selectedHabit) {
            ForEach(habits) { habit in
                HabitRow(habit: habit)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Habits")
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            dataController.delete(habit)
        }
    }
}

#Preview {
    ContentView()
}
