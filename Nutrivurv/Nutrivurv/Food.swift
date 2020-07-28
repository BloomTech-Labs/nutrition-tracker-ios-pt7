//
//  Food.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Food: Codable {
    let foodId: String
    let label: String
    let image: String?
    let category: String
}

struct Measure: Codable {
    let uri: String
    let label: String
}

struct FoodItem: Codable {
    let food: Food
    let measures: [Measure]
    
    // User generated properties when logging a food entry
    var quantity: Double?
    var servingSize: Int?
    var mealType: Int?
    var date: Date?
    
    init(food: Food, measures: [Measure], quantity: Double?, servingSize: Int?, mealType: Int?, date: Date? = Date()) {
        self.food = food
        self.measures = measures
        self.quantity = quantity
        self.servingSize = servingSize
        self.mealType = mealType
        self.date = date
    }
}

struct FoodSearch: Decodable {
    let hints: [FoodItem]
}
