//
//  NoHabitView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/27/26.
//

import SwiftUI

struct NoHabitView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No Habit Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New Habit", action: dataController.newHabit)
    }
}

#Preview {
    NoHabitView()
}
