//
//  File.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/30/26.
//
import Foundation

extension DataController {
	/// Creates 5 Tags and 10 Habits in each tag with random values for previewing
	/// and testing purposes.
	func createSampleData() {
		let viewContext = container.viewContext

		for tagCount in 1...5 {
			let tag = Tag(context: viewContext)
			tag.id = UUID()
			let tagFormat = NSLocalizedString("Tag %lld", comment: "")
			tag.name = String.localizedStringWithFormat(tagFormat, tagCount)

			for habitCount in 1...10 {
				let habit = Habit(context: viewContext)
				let titleFormat = NSLocalizedString("Habit %lld-%lld", comment: "")
				habit.title = String.localizedStringWithFormat(titleFormat, tagCount, habitCount)
				let contentFormat = NSLocalizedString("Description of habit %lld-%lld", comment: "")
				habit.content = String.localizedStringWithFormat(contentFormat, tagCount, habitCount)
				habit.creationDate = .now
				habit.completed = Bool.random()
				habit.priority = Int16.random(in: 0...2)
				tag.addToHabits(habit)
			}
		}

		try? viewContext.save()
	}
}
