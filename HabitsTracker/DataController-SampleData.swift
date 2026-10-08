//
//  DataController-SampleData.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/30/26.
//

import CoreData
import Foundation

extension DataController {
    private enum SampleTags: String, CaseIterable, Codable {
        case health = "Health"
        case fitness = "Fitness"
        case productivity = "Productivity"
        case mindfulness = "Mindfulness"
        case learning = "Learning"
        case finance = "Finance"
        case social = "Social"
    }

    private struct SampleHabit {
        let title: String
        let description: String
        let category: SampleTags
        let daysAgo: Int
        let isCompleted: Bool
    }

    private func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }

    private static let samples: [SampleHabit] = [
        SampleHabit(
            title: "Drink 8 glasses of water",
            description: "Stay hydrated by drinking at least 2 liters of water.",
            category: .health,
            daysAgo: 30,
            isCompleted: true
        ),

        SampleHabit(
            title: "Morning run",
            description: "Run for 30 minutes before breakfast.",
            category: .fitness,
            daysAgo: 25,
            isCompleted: false
        ),

        SampleHabit(
            title: "Meditate for 10 minutes",
            description: "Practice mindful breathing to reduce stress.",
            category: .mindfulness,
            daysAgo: 21,
            isCompleted: true
        ),

        SampleHabit(
            title: "Read 20 pages",
            description: "Read a book for at least 20 pages before bed.",
            category: .learning,
            daysAgo: 18,
            isCompleted: false
        ),

        SampleHabit(
            title: "Plan tomorrow's tasks",
            description: "Write down the top three priorities for the next day.",
            category: .productivity,
            daysAgo: 14,
            isCompleted: true
        ),

        SampleHabit(
            title: "Track daily expenses",
            description: "Log every purchase in a budgeting app.",
            category: .finance,
            daysAgo: 10,
            isCompleted: false
        ),

        SampleHabit(
            title: "Stretch for 15 minutes",
            description: "Full-body stretching to improve flexibility and posture.",
            category: .fitness,
            daysAgo: 7,
            isCompleted: true
        ),

        SampleHabit(
            title: "Call a friend or family member",
            description: "Reach out to someone you care about and catch up.",
            category: .social,
            daysAgo: 5,
            isCompleted: false
        ),

        SampleHabit(
            title: "Practice Swift for 30 minutes",
            description: "Work through a coding exercise or build a small SwiftUI feature.",
            category: .learning,
            daysAgo: 3,
            isCompleted: true
        ),

        SampleHabit(
            title: "Sleep before 11 PM",
            description: "Wind down early and get 7–8 hours of sleep.",
            category: .health,
            daysAgo: 1,
            isCompleted: false
        ),

        SampleHabit(
            title: "Eat a serving of vegetables with every meal",
            description: "Add at least one vegetable to breakfast, lunch and dinner.",
            category: .health,
            daysAgo: 45,
            isCompleted: true
        ),

        SampleHabit(
            title: "Take a daily vitamin",
            description: "Take your vitamins with breakfast so it becomes automatic.",
            category: .health,
            daysAgo: 12,
            isCompleted: false
        ),

        SampleHabit(
            title: "Strength training 3x per week",
            description: "Do a 40-minute full-body workout on Monday, Wednesday and Friday.",
            category: .fitness,
            daysAgo: 40,
            isCompleted: false
        ),

        SampleHabit(
            title: "Walk 10,000 steps",
            description: "Hit your daily step goal by walking at lunch or after dinner.",
            category: .fitness,
            daysAgo: 16,
            isCompleted: true
        ),

        SampleHabit(
            title: "Inbox zero before 5 PM",
            description: "Clear, archive or reply to every email before the end of the workday.",
            category: .productivity,
            daysAgo: 28,
            isCompleted: false
        ),

        SampleHabit(
            title: "Deep work block",
            description: "Spend 90 uninterrupted minutes on your most important task with notifications off.",
            category: .productivity,
            daysAgo: 9,
            isCompleted: true
        ),

        SampleHabit(
            title: "Gratitude journal",
            description: "Write down three things you're grateful for before bed.",
            category: .mindfulness,
            daysAgo: 35,
            isCompleted: true
        ),

        SampleHabit(
            title: "Digital sunset",
            description: "Put screens away 30 minutes before bedtime and unwind offline.",
            category: .mindfulness,
            daysAgo: 4,
            isCompleted: false
        ),

        SampleHabit(
            title: "Review monthly budget",
            description: "Compare actual spending to your budget and adjust categories.",
            category: .finance,
            daysAgo: 20,
            isCompleted: false
        ),

        SampleHabit(
            title: "Move $20 to savings",
            description: "Transfer a small amount to your savings account every week.",
            category: .finance,
            daysAgo: 2,
            isCompleted: true
        ),

        SampleHabit(
            title: "Learn 10 new vocabulary words",
            description: "Study a new set of words in a language you're learning using flashcards.",
            category: .learning,
            daysAgo: 22,
            isCompleted: false
        ),

        SampleHabit(
            title: "Weekly dinner with friends",
            description: "Plan one meal each week with friends or family, in person.",
            category: .social,
            daysAgo: 6,
            isCompleted: true
        )
    ]

    func createSampleData() {
        let viewContext = container.viewContext

        for tagName in SampleTags.allCases {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = tagName.rawValue

            let habitsByTag = DataController.samples.filter({$0.category == tagName})

            for sampleHabit in habitsByTag {
                let habit = Habit(context: viewContext)
                habit.title = sampleHabit.title
                habit.content = sampleHabit.description
                habit.creationDate = daysAgo(sampleHabit.daysAgo)
                habit.completed = sampleHabit.isCompleted
                habit.priority = Int16.random(in: 0...2)
                tag.addToHabits(habit)
            }
        }

        try? viewContext.save()
    }
}
