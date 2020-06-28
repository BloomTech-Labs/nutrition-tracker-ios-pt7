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
    let image: String?
    let category: String
}

struct Measure: Decodable, Equatable {
    let uri: String
    let label: String
}

struct FoodItem: Decodable, Equatable {
    let food: Food
    let measures: [Measure]
    
    // User generated properties when logging a food entry
    var quantity: Double?
    var servingSize: Int?
    var mealType: Int?
}

struct FoodSearch: Decodable, Equatable {
    let hints: [FoodItem]
}
