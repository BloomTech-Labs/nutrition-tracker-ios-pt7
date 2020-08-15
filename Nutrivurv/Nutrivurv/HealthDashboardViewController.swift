//
//  HealthDashboardViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import HealthKit

class HealthDashboardViewController: UIHostingController<HealthDashboardView> {
    var activeCalories: [(String, Int)]?{
        didSet {
            calculateCaloricDeficits()
        }
    }
    
    var basalCalories: [(String, Int)]? {
        didSet {
            calculateCaloricDeficits()
        }
    }
    
    var consumedCalories: [(String, Int)]? {
        didSet {
            calculateCaloricDeficits()
        }
    }
    
    var caloricDeficits: [(String, Int)] = []
    
    var missingData: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HealthDashboardView(activeCalories: Calories(), caloricDeficit: Calories(), dailyMacros: FoodLogController.shared.totalDailyMacrosModel))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "bg-color")!
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "bg-color")!
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "bg-color")!
        
        if let activeCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            self.getCalorieStatsCollectionForWeek(using: activeCalsBurned)
        }
        
        if let consumedCals = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) {
            self.getCalorieStatsCollectionForWeek(using: consumedCals)
        }
        
        if let basalCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned) {
            self.getCalorieStatsCollectionForWeek(using: basalCalsBurned)
        }
    }
    
    private func getCalorieStatsCollectionForWeek(using quantityType: HKQuantityType) {
        HealthKitController.getCumulativeStatsCollectionUsingOneDayInterval(for: quantityType) { (statsCollection, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let statsCollection = statsCollection else {
                print("error with stats collection data")
                return
            }
            
            let endDate = Date()
            
            guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: endDate) else {
                print("error getting start date for statistics collection")
                return
            }
            
            var activeCaloriesByDay: [(String, Int)] = []
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                if let caloriesSum = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let weekDay = Calendar.current.component(.weekday, from: date)
                    
                    let dateFormatter = DateFormatter()
                    let weekDayString = dateFormatter.weekdaySymbols[weekDay - 1]
                    
                    let calorieDouble = caloriesSum.doubleValue(for: HKUnit.kilocalorie())
                    let calorieInt = Int(calorieDouble)
                    
                    activeCaloriesByDay.append((weekDayString, calorieInt))
                }
            }
            
            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
                self.activeCalories = activeCaloriesByDay
                
                self.rootView.activeCalories.day1Label = activeCaloriesByDay[0].0
                self.rootView.activeCalories.day1Count = activeCaloriesByDay[0].1
                
                self.rootView.activeCalories.day2Label = activeCaloriesByDay[1].0
                self.rootView.activeCalories.day2Count = activeCaloriesByDay[1].1
                
                self.rootView.activeCalories.day3Label = activeCaloriesByDay[2].0
                self.rootView.activeCalories.day3Count = activeCaloriesByDay[2].1
                
                self.rootView.activeCalories.day4Label = activeCaloriesByDay[3].0
                self.rootView.activeCalories.day4Count = activeCaloriesByDay[3].1
                
                self.rootView.activeCalories.day5Label = activeCaloriesByDay[4].0
                self.rootView.activeCalories.day5Count = activeCaloriesByDay[4].1
                
                self.rootView.activeCalories.day6Label = activeCaloriesByDay[5].0
                self.rootView.activeCalories.day6Count = activeCaloriesByDay[5].1
                
                self.rootView.activeCalories.day7Label = activeCaloriesByDay[6].0
                self.rootView.activeCalories.day7Count = activeCaloriesByDay[6].1
                
            case HKQuantityTypeIdentifier.basalEnergyBurned.rawValue:
                self.basalCalories = activeCaloriesByDay
            case HKQuantityTypeIdentifier.dietaryEnergyConsumed.rawValue:
                self.consumedCalories = activeCaloriesByDay
            default:
                return
            }
        }
    }
    
    private func calculateCaloricDeficits() {
        
        guard let activeCals = activeCalories, activeCals.count == 7, let basalCals = basalCalories, basalCals.count == 7, let consumedCals = consumedCalories, consumedCals.count == 7 else {
            return
        }
        
        for i in 0...6 {
            let dayOfWeek = activeCals[i].0

            var deficit = (activeCals[i].1 + basalCals[i].1) - consumedCals[i].1
            
            if consumedCals[i].1 == 0 {
                self.missingData = true
                deficit = 0
            }
            
            self.caloricDeficits.append((dayOfWeek, deficit))
        }
        
        self.rootView.caloricDeficit.day1Label = self.caloricDeficits[0].0
        self.rootView.caloricDeficit.day1Count = self.caloricDeficits[0].1
        
        self.rootView.caloricDeficit.day2Label = self.caloricDeficits[1].0
        self.rootView.caloricDeficit.day2Count = self.caloricDeficits[1].1
        
        self.rootView.caloricDeficit.day3Label = self.caloricDeficits[2].0
        self.rootView.caloricDeficit.day3Count = self.caloricDeficits[2].1
        
        self.rootView.caloricDeficit.day4Label = self.caloricDeficits[3].0
        self.rootView.caloricDeficit.day4Count = self.caloricDeficits[3].1
        
        self.rootView.caloricDeficit.day5Label = self.caloricDeficits[4].0
        self.rootView.caloricDeficit.day5Count = self.caloricDeficits[4].1
        
        self.rootView.caloricDeficit.day6Label = self.caloricDeficits[5].0
        self.rootView.caloricDeficit.day6Count = self.caloricDeficits[5].1
        
        self.rootView.caloricDeficit.day7Label = self.caloricDeficits[6].0
        self.rootView.caloricDeficit.day7Count = self.caloricDeficits[6].1
    }
}
