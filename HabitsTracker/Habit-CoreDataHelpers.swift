//
//  Habit-CoreDataHelpers.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/26/26.
//

import Foundation
import CoreData

extension Habit {
    var habitTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    var habitContent: String {
        get { content ?? "" }
        set { content = newValue }
    }
    
    var habitCreationDate: Date? {
        creationDate ?? .now
    }
    
    var habitModificationDate: Date? {
        modificationDate ?? .now
    }
    
    static var example: Habit {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let habit = Habit(context: viewContext)
        habit.title = "Example"
        habit.content = "Example content"
        habit.priority = 2
        habit.creationDate = .now
        return habit
    }
}
