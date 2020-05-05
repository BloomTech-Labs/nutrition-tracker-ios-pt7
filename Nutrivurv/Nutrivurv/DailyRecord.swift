//
//  DailyRecord.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 4/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct DailyRecord: Codable {
    var date: String
    var calories: Int
    var fat: Int
    var carbs: Int
    var fiber: Int
    var protein: Int
    var food_string: String
    var meal_type: String
}
