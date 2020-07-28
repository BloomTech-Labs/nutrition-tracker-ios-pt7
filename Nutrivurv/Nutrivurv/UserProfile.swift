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
    //    var userAuth: UserAuth
    var birthDate: String
    var weight: Int
    var heightFeet: Int
    var heightInches: Int
    var gender: String
    var goalWeight: String
    var activityLevel: String
    var weeklyWeightChangeGoal: Int
    var fatPctRatio: String
    var fatBudget: Int
    var carbsPctRatio: String
    var carbsBudget: Int
    var proteinPctRatio: String
    var proteinBudget: Int
    var caloricBudget: Int
    
    
    init(id: Int, birthDate: String, weight: Int, heightFeet: Int, heightInches: Int, gender: String, goalWeight: String, activityLevel: String, weeklyWeightChangeGoal: Int,
         fatPctRatio: String, fatBudget: Int, carbsPctRatio: String, carbsBudget: Int, proteinPctRatio: String, proteinBudget: Int, caloricBudget: Int) {
        
        self.id = id
        //        self.userAuth = userAuth
        self.birthDate = birthDate
        self.weight = weight
        self.heightFeet = heightFeet
        self.heightInches = heightInches
        self.gender = gender
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
        case birthDate = "date_of_birth"
        case weight = "weight_lbs"
        case heightFeet = "height_ft"
        case heightInches = "height_in"
        case gender
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
