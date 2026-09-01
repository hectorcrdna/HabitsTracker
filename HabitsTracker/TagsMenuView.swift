//
//  TagsMenuView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/31/26.
//

import SwiftUI

struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

    var body: some View {
        Menu {
            ForEach(habit.habitTags) { tag in
                Button {
                    habit.removeFromTags(tag)
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }

            let otherTags = dataController.missingTags(from: habit)

            if otherTags.isEmpty == false {
                Divider()

                Section("Add Tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            habit.addToTags(tag)
                        }
                    }
                }
            }
        } label: {
            Text(habit.habitTagsList)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: habit.habitTagsList)
        }

    }
}

#Preview {
    TagsMenuView(habit: .example)
}
