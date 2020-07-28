//
//  FoodLogController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class FoodLogController {
    static let shared = FoodLogController()
    
    @ObservedObject var dailyMacrosModel = DailyMacros()
    var dailyMacrosSubscriber: AnyCancellable?
    
    // Each of these macros below communicate via Combine with SwiftUI to update activity and macros view
    var caloriesCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.caloriesCount = caloriesCount
        }
    }
    
    var caloriesPct: CGFloat = 0.005 {
        didSet {
            dailyMacrosModel.caloriesPercent = caloriesPct
        }
    }
    
    var carbsCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.carbsCount = carbsCount
        }
    }
    
    var carbsPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.carbsPercent = carbsPct
           }
       }
    
    var proteinCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.proteinCount = proteinCount
        }
    }
    
    var proteinPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.proteinPercent = proteinPct
           }
       }
    
    var fatCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.fatCount = fatCount
        }
    }
    
    var fatPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.fatPercent = fatPct
           }
       }
    
    
    let defaultMealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    var foodLog: [FoodLogEntry] = []
    
    func createFoodLogEntry(entry: FoodLogEntry) {
        // POST
    }
    
    func editFoodLogEntry() {
        // PUT
    }
    
    func getFoodLogEntriesForDate() {
        // GET
    }
    
    func deleteFoodLogEntry() {
        // DELETE
    }
    
    
    private func subscribeToDailyMacros() {
        self.dailyMacrosSubscriber = dailyMacrosModel.objectWillChange.sink(receiveCompletion: {
            print("Completion received", $0)
            //            self.addActivityRingsProgressView()
        }, receiveValue: {
            print("Value received!", $0)
            //            self.addActivityRingsProgressView()
        })
    }
}
