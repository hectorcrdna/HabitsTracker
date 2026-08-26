//
//  Tag-CoreDataHelpers.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/26/26.
//

import Foundation
import CoreData

extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }
    
    var tagName: String {
        name ?? ""
    }
    
    var tagActiveHabits: [Habit] {
        let result = habits?.allObjects as? [Habit] ?? []
        return result.filter { $0.completed == false }
    }
    
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let tag = Tag(context: viewContext)
        tag.name = "Example"
        tag.id = UUID()
        return tag
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase
        
        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
