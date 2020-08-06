//
//  UserProfile.swift
//  Nutrivurv
//
//  Created by Dillon P on 7/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var id: Int
    var name: String
    var email: String
    var password: String
    var birthDate: String?
    var weight: Int?
    var heightFeet: Int?
    var heightInches: Int?
    var biologicalSex: BiologicalSex.RawValue?
    var goalWeight: String?
    var activityLevel: String?
    var weeklyWeightChangeGoal: Int?
    var fatPctRatio: String
    var fatBudget: Int?
    var carbsPctRatio: String
    var carbsBudget: Int?
    var proteinPctRatio: String
    var proteinBudget: Int?
    var caloricBudget: Int?
        
        init(id: Int, name: String, email: String, password: String, birthDate: String? = nil, weight: Int? = nil, heightFeet: Int? = nil, heightInches: Int? = nil, biologicalSex: BiologicalSex.RawValue? = nil, goalWeight: String? = nil, activityLevel: String? = nil, weeklyWeightChangeGoal: Int? = nil,
        fatPctRatio: String, fatBudget: Int? = nil, carbsPctRatio: String, carbsBudget: Int? = nil, proteinPctRatio: String, proteinBudget: Int? = nil, caloricBudget: Int? = nil) {
            
            self.id = id
            self.name = name
            self.email = email
            self.password = password
            self.birthDate = birthDate
            self.weight = weight
            self.heightFeet = heightFeet
            self.heightInches = heightInches
            self.biologicalSex = biologicalSex
            self.goalWeight = goalWeight
            self.activityLevel = activityLevel
            self.weeklyWeightChangeGoal = weeklyWeightChangeGoal
            self.fatPctRatio = fatPctRatio
            self.fatBudget = fatBudget
            self.carbsPctRatio = carbsPctRatio
            self.carbsBudget = carbsBudget
            self.proteinPctRatio = proteinPctRatio
            self.proteinBudget = proteinBudget
            self.caloricBudget = caloricBudget
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case password
        case birthDate = "date_of_birth"
        case weight = "weight_lbs"
        case heightFeet = "height_ft"
        case heightInches = "height_in"
        case biologicalSex = "gender"
        case goalWeight = "target_weight_lbs"
        case activityLevel = "activity_level"
        case weeklyWeightChangeGoal = "net_weekly_weight_change_lbs"
        case fatPctRatio = "fat_ratio_prct"
        case fatBudget = "fat_budget_g"
        case carbsPctRatio = "carb_ratio_prct"
        case carbsBudget = "carb_budget_g"
        case proteinPctRatio = "protein_ratio_prct"
        case proteinBudget = "protein_budget_g"
        case caloricBudget = "caloric_budget_kcal"
    }
}

enum BiologicalSex: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
}
