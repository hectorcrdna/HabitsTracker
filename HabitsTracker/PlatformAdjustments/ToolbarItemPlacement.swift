//
//  ToolbarItemPlacement.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/28/26.
//

import SwiftUI

extension ToolbarItemPlacement {
	#if os(watchOS)
	static let automaticOrLeading: ToolbarItemPlacement = .topBarLeading
	static let automaticOrTrailing: ToolbarItemPlacement = .topBarTrailing
	#else
	static let automaticOrLeading: ToolbarItemPlacement = .automatic
	static let automaticOrTrailing: ToolbarItemPlacement = .automatic
	#endif

}
