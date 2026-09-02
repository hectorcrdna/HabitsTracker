//
//  DetailView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/23/26.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        VStack {
            if let habit = dataController.selectedHabit {
                HabitView(habit: habit)
            } else {
                NoHabitView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
}
