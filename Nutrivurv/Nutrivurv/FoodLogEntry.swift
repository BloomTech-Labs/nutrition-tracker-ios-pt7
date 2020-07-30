//
//  FoodLogEntry.swift
//  Nutrivurv
//
//  Created by Dillon on 7/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct FoodLogEntry: Codable {
    var date: String
    var mealType: String
    var foodID: String
    var measurementURI: String
    var measurementName: String
    var foodName: String
    var quantity: Int
    var calories: Int
    var fat: String
    var carbs: String
    var protein: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case mealType = "meal_type"
        case foodID = "edamam_food_id"
        case measurementURI = "measurement_uri"
        case measurementName = "measurement_name"
        case foodName = "food_name"
        case quantity
        case calories = "calories_kcal"
        case fat = "fat_g"
        case carbs = "carbs_g"
        case protein = "protein_g"
    }
}