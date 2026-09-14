//
//  Award.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 8/29/26.
//

import Foundation

/// An award the user can unlock by meeting goals while using the app, decoded from a JSON in the apps Bundle.
struct Award: Decodable, Identifiable {
    var id: String { name }
    var name: String
    var description: String
    var color: String
    var criterion: String
    var value: Int
    var image: String

    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    static let example = allAwards[0]
}
