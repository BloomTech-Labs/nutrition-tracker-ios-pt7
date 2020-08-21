//
//  MockFoodLogEntry.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class MockFoodLogEntry {
    static let shared = MockFoodLogEntry()
    
    var foodLogEntry: FoodLogEntry?
    
    init() {
        let newEntry = FoodLogEntry(id: 12, date: "8-21-20", mealType: MealType.lunch.rawValue, foodID: "1234567", measurementURI: "123455", measurementName: "Serving", allMeasurements: [Measurement(uri: "1213233", label: "serving")], foodName: "Banana", quantity: "1.0", calories: 102, fat: "14", carbs: "42", protein: "8", imageURL: nil)
        
        self.foodLogEntry = newEntry
    }
}
