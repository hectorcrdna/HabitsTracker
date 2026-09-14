//
//  DataController.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/23/26.
//

import CoreData
import Combine
import SwiftUI

// IMPORTANT: The raw values directly match CoreData's property names,
// do not change one without changing the other.
/// A filter menu options to sort habits by date,
/// including CoreData's Habit class `Date` properties as raw value.
enum SortType: String {
	/// A **creation date** sort order.
    case dateCreated = "creationDate"
	/// A **last modified date** sort order.
    case dateModified = "modificationDate"
}

/// A filter menu options to filter habits by completion status.
enum Status {
	/// No filter is applied.
    case all
	/// Only show incomplete habits.
	case open
	/// Only show completed habits.
	case closed
}

/// Singleton class for the managing of local and remote data.
class DataController: ObservableObject {

	/// The container tasked with managing CoreData Models with CloudKit.
    let container: NSPersistentCloudKitContainer

	/// The current Filter selected by the user in SidebarView List.
    @Published var selectedFilter: Filter? = .all

	/// The current Habit selected by the user in ContentView List.
    @Published var selectedHabit: Habit?

	/// The text bound to the search bar in ContentView.
    @Published var filterText = ""
	/// An array of Tags that serve as tokens for filtering search results when using the search bar.
    @Published var filterTokens = [Tag]()

	// ContentView's Toolbar Filter Menu options.
	/// A filter menu on/off switch.
    @Published var filterEnabled = false
	/// A filter menu option to filter by priority: -1 = all, 0 = low, 1 = medium, 2 = high.
    @Published var filterPriority = -1
	/// A filter menu option to filter by completion.
    @Published var filterStatus = Status.all
	/// A filter menu option to sort by date.
    @Published var sortType = SortType.dateCreated
	/// A filter menu option to sort by most recent.
    @Published var sortNewestFirst = true

	/// The Task that handles saving for the ``queueSave()`` Method.
    private var saveTask: Task<Void, Error>?

	/// The ManagedObjectModel for CoreData.
	///
	/// Created as a workaround for a crashing error
	/// *“Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Tag' so +entity is unable to disambiguate.”*
	/// causing duplicate object models being created when unit testing.
	static let model: NSManagedObjectModel = {
		guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
			fatalError("Failed to locate model file.")
		}

		guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
			fatalError("Failed to load model file.")
		}

		return managedObjectModel
	}()

	/// A preview created for Canvas view.
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()

	/// An array of tokens to show when the user types # in the search bar.
    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else { return [] }

        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)

        let request = Tag.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }

	/// Initializes the CoreData persistent store in memory or on disk
	/// and sets the options for merging changes across devices.
	/// - Parameter inMemory: If `true` data will not be saved to disk and
	/// discarded once the app finishes, used for previewing purposes. Defaults to `false`.
    init(inMemory: Bool = false) {

		// Container initialized with the static property 'model' to avoid crash error.
		container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        container.persistentStoreDescriptions.first?.setOption(
			true as NSNumber,
			forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
		)

		// An Observer added to update UI when remote changes happen.
        NotificationCenter.default.addObserver(
			forName: .NSPersistentStoreRemoteChange,
			object: container.persistentStoreCoordinator,
			queue: .main,
			using: remoteStoreChanged
		)

        container.loadPersistentStores { ( _, error) in
            if let error {
                fatalError("Error loading persistent stores: \(error.localizedDescription)")
            }
        }

		// If were running test in Debug we delete all data to start
		// with a clean slate every time we launch and disabled
		// animations to make UI Test Faster.
		#if DEBUG
		if CommandLine.arguments.contains("enable-testing") {
			self.deleteAll()
			UIView.setAnimationsEnabled(false)
		}
		#endif
    }

	/// Tells the UI there has been remote changes, fired by the observer added to ``init(inMemory:)``.
	/// - Parameter notification: Information related to the change.
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

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

	/// Saves any data only iff there has been changes.
    func save() {
		// Cancels any save task that may be waiting so there are no multiple saves.
        saveTask?.cancel()

        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

	/// Queues the ``save()`` method to fire after 3 seconds.
    func queueSave() {
		// Cancels any save task that may be waiting so there are no multiple saves.
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }

	/// Deletes a single specified object and then saves the change.
	/// - Parameter object: The Tag or Habit to be deleted.
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }

	/// Deletes multiple objects in a fetch request.
	///
	/// Private method used  in ``deleteAll()``.
	/// - Parameter fetchRequest: The fetch request of Tags or Habits to be deleted.
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

		// deleting a fetch request requires to execute the delete on the viewContext remotely to get the ID's of the
		// objects that are going to be deleted then merge those changes into the viewContext.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

	/// Deletes all Tags and Habits from disk then saves the change.
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        delete(request2)

        save()
    }

	/// Gets all the tags that are currently not assigned to a habit.
	/// - Parameter habit: The habit to compare tags.
	/// - Returns: An array of Tags not assigned to the habit.
    func missingTags(from habit: Habit) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(habit.habitTags)

        return difference.sorted()
    }

	/// Filters out habits based on `SidebarView` filter selection, menu filter selection and search bar result.
	/// - Returns: An filtered array of habits.
    func habitsForSelectedFilter() -> [Habit] {
		// Gets the selected filter in `SidebarView`.
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()

		// If the selected filter is a tag
		// only show habits with that tag.
        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)

        } else {
			// If the selected filter is not a tag
			// then filter by modification date.
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }

		// Gets the text from the search bar.
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)

            let combinedPredicate = NSCompoundPredicate(
				orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
			)

            predicates.append(combinedPredicate)
        }

        if filterTokens.isEmpty == false {
            let tokenPredicate = NSPredicate(format: "ANY tags in %@", filterTokens)
            predicates.append(tokenPredicate)
        }

		// If the menu filter in `ContentView` is enabled
		// then add those filters.
        if filterEnabled {
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }

            if filterStatus != .all {
                let lookForClosed = filterStatus == .closed
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }

        let request = Habit.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

        let allHabits = (try? container.viewContext.fetch(request)) ?? []
        return allHabits
    }

	/// Creates a new Tag with a default name then saves the change.
    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag.")
        save()
    }

	/// Creates a new Habit with a default name then saves the change.
	///
	/// If the habit is created while browsing a tag that tag will be set to the
	/// habits tag array and ``selectedHabit`` will be set to the new tag
	/// so ``DetailView`` will update.
    func newHabit() {
        let habit = Habit(context: container.viewContext)
        habit.title =  NSLocalizedString("New habit", comment: "Create a new habit.")
        habit.creationDate = .now
        habit.priority = 1

        if let tag = selectedFilter?.tag {
            habit.addToTags(tag)
        }
        save()

        selectedHabit = habit
    }

	/// Counts the total amount of Tags or Habits saved.
	///
	/// Uses a generic type T to handle Tags or Habits fetch request.
	/// - Parameter fetchRequest: The Habit or Tag fetch request.
	/// - Returns: An int - the count of objects in the fetch request.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

	/// Returns true if the user has earned the award.
	/// - Parameter award: The award to query.
	/// - Returns: A Bool indicating if the award has been earned.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "habits":
            let fetchRequest = Habit.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "closed":
            let fetchRequest = Habit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "tags":
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
			fatalError("Unknown award criterion \(award.criterion)")
        }
    }
}
