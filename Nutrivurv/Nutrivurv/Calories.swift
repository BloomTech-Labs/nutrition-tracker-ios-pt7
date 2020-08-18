//
//  Calories.swift
//  Nutrivurv
//
//  Created by Dillon on 8/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUICharts

class Calories: ObservableObject {
    let objectWillChange = PassthroughSubject<Any, Never>()
    
    @Published var day1Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day1Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day2Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day2Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day3Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day3Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day4Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day4Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day5Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day5Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day6Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day6Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var day7Label: String = "" {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    @Published var day7Count: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var average: Int = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var dailyProgressPercent: CGFloat = 0 {
        willSet {
            objectWillChange.send(newValue)
        }
    }
}
