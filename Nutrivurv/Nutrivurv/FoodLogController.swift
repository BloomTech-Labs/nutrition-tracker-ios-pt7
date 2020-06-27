//
//  FoodLogController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class FoodLogController {
    static let shared = FoodLogController()
    
    // Futrue release will incorporate table view sectioned by meal type, but for now just using a single section
//    var foodLogDictionary: [String: [FoodItem]] = [:] {
//        didSet {
//            NotificationCenter.default.post(name: .newFoodItemLogged, object: nil)
//            // TODO: log food to backend
//        }
//    }
    
    var foodLog: [FoodItem] = [] {
        didSet {
            NotificationCenter.default.post(name: .newFoodItemLogged, object: nil)
            // TODO: log food to backend
        }
    }
    
    // Once the REST backend is updated to allow logging food, will need to handle this here as well
}
