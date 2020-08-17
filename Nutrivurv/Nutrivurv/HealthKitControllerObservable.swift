//
//  HealthKitControllerObservable.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine


class HealthKitControllerObservable: ObservableObject {
    
    static let shared = HealthKitControllerObservable()
    
    let objectWillChange = PassthroughSubject<Any, Never>()
    
    @Published var activeCalories: Calories = Calories() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var consumedCalories: Calories = Calories() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var caloricDeficits: Calories = Calories() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var weight: Weight = Weight() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var bodyFat: Weight = Weight() {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    
}
