//
//  FoodLog.swift
//  Nutrivurv
//
//  Created by Dillon on 7/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct FoodLog: Codable {
    var breakfast: [FoodLogEntry]?
    var lunch: [FoodLogEntry]?
    var dinner: [FoodLogEntry]?
    var snack: [FoodLogEntry]?
    var water: [FoodLogEntry]?
}
