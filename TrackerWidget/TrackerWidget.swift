//
//  TrackerWidget.swift
//  TrackerWidget
//
//  Created by Hector Cardona on 9/25/26.
//

import CoreData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date.now, habits: [.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
		let entry = SimpleEntry(date: Date.now, habits: loadHabits())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
		let entry = SimpleEntry(date: Date.now, habits: loadHabits())

		let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

	func loadHabits() -> [Habit] {
		let dataController = DataController()
		let request = dataController.fetchRequestForTopHabits(count: 7)
		return dataController.results(for: request)
	}

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let habits: [Habit]
}

struct TrackerWidgetEntryView: View {
	@Environment(\.widgetFamily) var widgetFamily
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
    var entry: Provider.Entry

	var habits: ArraySlice<Habit> {
		var count: Int

		switch widgetFamily {
		case .systemSmall:
			count = 2
		case .systemLarge, .systemExtraLarge, .systemExtraLargePortrait:
			if dynamicTypeSize < .xLarge {
				count = 7
			} else {
				count = 5
			}
		default:
			if dynamicTypeSize < .xLarge {
				count = 3
			} else {
				count = 2
			}
		}
		return entry.habits.prefix(count)
	}

    var body: some View {
        VStack(spacing: 10) {
			ForEach(habits) { habit in
				Link(destination: habit.objectID.uriRepresentation()) {
					VStack(alignment: .leading) {
						Text(habit.habitTitle)
							.font(.headline)
							.layoutPriority(1)

						if habit.habitTags.isEmpty == false {
							Text(habit.habitTagsList)
								.foregroundStyle(.secondary)
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
		}
    }
}

struct TrackerWidget: Widget {
    let kind: String = "TrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TrackerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TrackerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Up Next…")
        .description("Your most important habits.")
    }
}

#Preview(as: .systemSmall) {
    TrackerWidget()
} timeline: {
	SimpleEntry(date: .now, habits: [.example])
    SimpleEntry(date: .now, habits: [.example])
}
