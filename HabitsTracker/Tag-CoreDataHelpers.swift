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
    
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let tag = Tag(context: viewContext)
        tag.name = "Example"
        tag.id = UUID()
        return tag
    }
}
