//
//  NutritionFacts.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import Combine

class NutritionFacts: ObservableObject {
    let objectWillChange = PassthroughSubject<Any, Never>()
    
    @Published var calories: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var totalFat: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var totalFatDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var sodium: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var sodiumDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var totalCarb: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var cholesterol: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var cholesterolDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var sugar: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var protein: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var vitaminD: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var vitaminDDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var calcium: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var calciumDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var iron: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var ironDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var potassium: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    @Published var potassiumDailyPct: Double = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
}
