//
//  Food.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Food: Decodable, Equatable {
    let foodId: String
    let label: String
}

struct Measure: Decodable, Equatable {
    let uri: String
    let label: String
}

struct FoodItem: Decodable, Equatable {
    let food: Food
    let measures: [Measure]
}

struct FoodSearch: Decodable, Equatable {
    let hints: [FoodItem]
}
