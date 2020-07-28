//
//  ActivityRing.swift
//  Nutrivurv
//
//  Created by Dillon on 7/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import Combine

class DailyMacros: ObservableObject {
    let objectWillChange = PassthroughSubject<CGFloat, Never>()
    
    // Calories count and percent values updated from UIKit
    @Published var caloriesCount: CGFloat = 0 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
    @Published var caloriesPercent: CGFloat = 0.005 {
        willSet {
            self.objectWillChange.send(newValue)
        }
    }
    
    // Carbs count and percent values updated from UIKit
    @Published var carbsCount: CGFloat = 0 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
    @Published var carbsPercent: CGFloat = 0.005 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
    
    // Protein count and percent values updated from UIKit
    @Published var proteinCount: CGFloat = 0 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
    @Published var proteinPercent: CGFloat = 0.005 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }

    // Fat count and percent values updated from UIKit
    @Published var fatCount: CGFloat = 0 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
    @Published var fatPercent: CGFloat = 0.005 {
           willSet {
               self.objectWillChange.send(newValue)
           }
       }
}
