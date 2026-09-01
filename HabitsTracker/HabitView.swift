//
//  HabitView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/27/26.
//

import SwiftUI
import CoreData

struct HabitView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $habit.habitTitle, prompt: Text("Enter the habit title here"))
                        .font(.title)

                    Text("**Modified:** \(habit.habitModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("**Status:**")
                            .foregroundStyle(.secondary)

                        Text(LocalizedStringKey(habit.habitStatus))
                            .foregroundStyle(.secondary)
                    }
                }

                Picker("Priority", selection: $habit.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }

                TagsMenuView(habit: habit)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField(
						"Description",
						text: $habit.habitContent,
						prompt: Text("Enter the habit description here"),
						axis: .vertical
					)

                }
            }
        }
        .disabled(habit.isDeleted)
        .onReceive(habit.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            HabitViewToolbar(habit: habit)
        }
    }
}

#Preview {
    HabitView(habit: .example)
}
