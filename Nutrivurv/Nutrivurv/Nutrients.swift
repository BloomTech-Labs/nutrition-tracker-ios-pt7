//
//  Nutrients.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Nutrients: Decodable, Equatable {
    let yield: Double
    let calories: Int
    let totalWeight: Double
    let dietLabels: [String]
    let healthLabels: [String]
    let cautions: [String]
    let totalNutrients: TotalNutrientType
    let totalDaily: DailyNutrientType
    let ingredients: [Ingredients]
}

struct TotalNutrientType: Decodable, Equatable {
    let FAT: Nutrient
    let NA: Nutrient
    let CHOCDF: Nutrient
    let CHOLE: Nutrient
    let SUGAR: Nutrient
    let PROCNT: Nutrient
    let VITD: Nutrient
    let CA: Nutrient
    let FE: Nutrient
    let K: Nutrient
}

struct DailyNutrientType: Decodable, Equatable {
    let FAT: Nutrient
    let NA: Nutrient
    let CHOCDF: Nutrient
    let CHOLE: Nutrient
    let PROCNT: Nutrient
    let VITD: Nutrient
    let CA: Nutrient
    let FE: Nutrient
    let K: Nutrient
    let FIBTG: Nutrient
}

struct Nutrient: Decodable, Equatable {
    let label: String
    let quantity: Double
    let unit: String
}

struct Ingredients: Decodable, Equatable {
    let parsed: [ParsedIngredients]
}

struct ParsedIngredients: Decodable, Equatable {
    let quantity: Double
    let measure: String
    let food: String
    let foodId: String
    let weight: Double
    let retainedWeight: Double
    let measureURI: String
    let status: String
}
