//
//  InlineNavigationBar.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/27/26.
//

import SwiftUI

extension View {
	func inlineNavigationBar() -> some View {
		#if os(macOS)
		self
		#else
		self.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}
