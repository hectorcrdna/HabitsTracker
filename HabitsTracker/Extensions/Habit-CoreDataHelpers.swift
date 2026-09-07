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

    var habitCreationDate: Date {
        creationDate ?? .now
    }

    var habitModificationDate: Date {
        modificationDate ?? .now
    }

    var habitTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }

    var habitTagsList: String {
		let noTags = NSLocalizedString("No tags", comment: "The user has not added any tags to this habit.")
        guard let tags else { return noTags }

        if tags.count == 0 {
            return noTags
        } else {
            return habitTags.map(\.tagName).formatted()
        }
    }

    var habitStatus: String {
        if completed {
            return NSLocalizedString("Completed", comment: "This habit has been completed.")
        } else {
            return NSLocalizedString("Incomplete", comment: "This habit is has not been completed.")
        }
    }

    var habitFormattedCreationDate: String {
        habitCreationDate.formatted(date: .numeric, time: .omitted)
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

extension Habit: Comparable {
    public static func <(lhs: Habit, rhs: Habit) -> Bool {
        let left = lhs.habitTitle.localizedLowercase
        let right = rhs.habitTitle.localizedLowercase

        if left == right {
            return lhs.habitCreationDate < rhs.habitCreationDate
        } else {
            return left < right
        }
    }
}
