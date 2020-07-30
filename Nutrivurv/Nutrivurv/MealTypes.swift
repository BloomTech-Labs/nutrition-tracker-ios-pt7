//
//  MealTypes.swift
//  Nutrivurv
//
//  Created by Dillon on 7/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

enum MealType: String, CaseIterable, Codable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
    case water = "water"
}

