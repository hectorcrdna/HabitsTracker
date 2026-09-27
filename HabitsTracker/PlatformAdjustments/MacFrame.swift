//
//  MacFrame.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/27/26.
//

import SwiftUI

extension View {
	func macFrame(
		minWidth: CGFloat? = nil,
		maxWidth: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil
	) -> some View {
		#if os(macOS)
		self.frame(
			minWidth: minWidth,
			maxWidth: maxWidth,
			minHeight: minHeight,
			maxHeight: maxHeight
		)
		#else
		self
		#endif
	}

}
