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
    
    // Temporarily using the data returned from back end for the daily calorie budget instead of basal energy
//    var basalCalories: [(String, Int)]? {
//        didSet {
//            calculateCaloricDeficits()
//        }
//    }
    
    var consumedCalories: [(String, Int)]? {
        didSet {
            calculateCaloricDeficits()
        }
    }
    
    var caloricDeficits: [(String, Int)] = []
    
    var missingData: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HealthDashboardView(activeCalories: Calories(), caloricDeficit: Calories(), dailyMacros: FoodLogController.shared.totalDailyMacrosModel, userWeightData: Weight()))
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        if let activeCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            self.getCalorieStatsCollectionForWeek(using: activeCalsBurned)
        }
        
        if let consumedCals = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) {
            self.getCalorieStatsCollectionForWeek(using: consumedCals)
        }
        
        getWeightForLast30Days()
        // Healthkit appears to be way overestimating basal energy, so replacing with the information returned from backend for now.
//        if let basalCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned) {
//            self.getCalorieStatsCollectionForWeek(using: basalCalsBurned)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if missingData {
            notEnoughDataAlert()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset property to ensure the alert is only displayed once
        self.missingData = false
    }
    
    // MARK: - HealthKit Fecthing Methods
    
    private func getWeightForLast30Days() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("The weight sample type is not avaiable from HealtKit")
            return
        }
        
        let endDate = Date()
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -29, to: endDate) else {
            print("error getting start date for statistics collection")
            return
        }
        
        HealthKitController.getMostRecentSamples(for: weightSampleType, withStart: startDate, limit: 100) { (samples, error) in
            if let error = error {
                print("Error getting weight samples for health dashboard: \(error)")
                return
            }
            
            guard let samples = samples else {
                return
            }
            
            var weightReadings: [Double] = []
            
            for item in samples {
                let weight = item.quantity.doubleValue(for: HKUnit.pound()).roundToDecimal(1)
                weightReadings.append(weight)
            }
            
            print(weightReadings)
            
            self.rootView.userWeightData.weightReadings = weightReadings
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
            
            var caloriesByDay: [(String, Int)] = []
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                if let caloriesSum = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let weekDay = Calendar.current.component(.weekday, from: date)
                    
                    let dateFormatter = DateFormatter()
                    let weekDayString = dateFormatter.weekdaySymbols[weekDay - 1]
                    
                    let calorieDouble = caloriesSum.doubleValue(for: HKUnit.kilocalorie())
                    let calorieInt = Int(calorieDouble)
                    
                    caloriesByDay.append((weekDayString, calorieInt))
                }
            }
            
            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
                self.activeCalories = caloriesByDay
                
                self.rootView.activeCalories.day1Label = caloriesByDay[0].0
                self.rootView.activeCalories.day1Count = caloriesByDay[0].1
                
                self.rootView.activeCalories.day2Label = caloriesByDay[1].0
                self.rootView.activeCalories.day2Count = caloriesByDay[1].1
                
                self.rootView.activeCalories.day3Label = caloriesByDay[2].0
                self.rootView.activeCalories.day3Count = caloriesByDay[2].1
                
                self.rootView.activeCalories.day4Label = caloriesByDay[3].0
                self.rootView.activeCalories.day4Count = caloriesByDay[3].1
                
                self.rootView.activeCalories.day5Label = caloriesByDay[4].0
                self.rootView.activeCalories.day5Count = caloriesByDay[4].1
                
                self.rootView.activeCalories.day6Label = caloriesByDay[5].0
                self.rootView.activeCalories.day6Count = caloriesByDay[5].1
                
                self.rootView.activeCalories.day7Label = caloriesByDay[6].0
                self.rootView.activeCalories.day7Count = caloriesByDay[6].1
                
                // Temporarily using the data returned from back end for the daily calorie budget instead of basal energy
//            case HKQuantityTypeIdentifier.basalEnergyBurned.rawValue:
//                self.basalCalories = caloriesByDay
            case HKQuantityTypeIdentifier.dietaryEnergyConsumed.rawValue:
                self.consumedCalories = caloriesByDay
            default:
                return
            }
        }
    }
    
    private func calculateCaloricDeficits() {
        
        // Will use once HealthKit is able to accurately gather basal energy information
//        guard let activeCals = activeCalories, activeCals.count == 7, let basalCals = basalCalories, basalCals.count == 7, let consumedCals = consumedCalories, consumedCals.count == 7 else {
//            return
//        }
        
        guard let activeCals = activeCalories, let consumedCals = consumedCalories else {
            return
        }
        
        guard activeCals.count == 7, consumedCals.count == 7 else {
            self.missingData = true
            return
        }
        
        let basalCalories = UserDefaults.standard.integer(forKey: "caloricBudget")
        
        guard basalCalories > 0 else {
            print("Basal cals not loaading, prompt user to re-login")
            return
        }
        
        for i in 0...6 {
            let dayOfWeek = activeCals[i].0
            
            // Will use once HealthKit is able to accurately gather basal energy information
            // var deficit = (activeCals[i].1 + basalCals[i].1) - consumedCals[i].1
            
            let deficit = (basalCalories) - consumedCals[i].1
            
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
    
    private func notEnoughDataAlert() {
        let alertController = UIAlertController(title: "Missing Data", message: "In order to calculate your caloric deficits and get the most accurate depiction of your trends over time, you'll need to log at least one meal for any given day. Check back again after you've logged meals for 7 days straight!", preferredStyle: .alert)
        
        let alert = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alert)
        
        self.present(alertController, animated: true) {
            // Reset property to ensure the alert is only displayed once
            self.missingData = false
        }
    }
}
