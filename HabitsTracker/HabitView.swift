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
                    
                    Text("**Modified** \(habit.habitModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(habit.habitStatus)")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Priority", selection: $habit.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                
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
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $habit.habitContent, prompt: Text("Enter the habit description here"), axis: .vertical)
                        
                }
            }
        }
        .disabled(habit.isDeleted)
        .onReceive(habit.objectWillChange) { _ in
            dataController.queueSave()
        }
        .toolbar {
            Menu {
                Button {
                    UIPasteboard.general.string = habit.title
                } label: {
                    Label("Copy habit title", systemImage: "doc.on.doc")
                }
                
                Button {
                    habit.completed.toggle()
                    dataController.save()
                } label: {
                    Label(habit.completed ? "Mark Incomplet" : "Mark Completed", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                }
            } label: {
                Label("Actions", systemImage: "ellipsis.circle")
            }
        }
    }
}

#Preview {
    HabitView(habit: .example)
}
