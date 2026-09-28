//
//  NumberBadge.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/28/26.
//

import SwiftUI

extension View {
	func numberBadge(_ number: Int) -> some View {
		#if os(watchOS)
		self
		#else
		self.badge(number)
		#endif
	}
}
