//
//  Profile.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var age: Int
    var weight: Int
    var height: Int
    var gender: Bool?
    var goalWeight: Int?
    var activityLevel: Int?
    var fat: Int?
    var carbs: Int?
    var protein: Int?
    var fiber: Int?
    var calories: Int?
}
