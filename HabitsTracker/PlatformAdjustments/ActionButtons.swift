//
//  ActionButtons.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/30/26.
//

import SwiftUI

extension View {
	func actionButtons<T: View>(@ViewBuilder buttons: () -> T) -> some View {
		#if os(watchOS)
		self.swipeActions(edge: .trailing) {
			buttons()
		}
		#else
		self.contextMenu {
			buttons()
		}
		#endif
	}
}
