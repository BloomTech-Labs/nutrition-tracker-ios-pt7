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
    let objectWillChange = PassthroughSubject<Int, Never>()
    
    @Published var sundayCount: Int = 269 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var mondayCount: Int = 420 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var tuesdayCount: Int = 634 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var wednesdayCount: Int = 527 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var thursdayCount: Int = 428 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var fridayCount: Int = 783 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    @Published var saturdayCount: Int = 0 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
}
