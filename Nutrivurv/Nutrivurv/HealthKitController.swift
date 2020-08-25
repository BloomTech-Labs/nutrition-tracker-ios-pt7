//
//  HealthKitController.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import HealthKit


class HealthKitController: ObservableObject {
    
    static let shared = HealthKitController()
    
    func updateAllValues() {
        
        if let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            if !weightIsLoading {
                getBodyCompStatsForLast30Days(using: weightSampleType)
                weightIsLoading = true
            }
        }
        
        if let bodyFatSampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) {
            if !bodyFatIsLoading {
                getBodyCompStatsForLast30Days(using: bodyFatSampleType)
                bodyFatIsLoading = true
            }
        }
        
        if let activeCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            if !activeCalsIsLoading {
                getCalorieStatsCollectionForWeek(using: activeCalsBurned)
                activeCalsIsLoading = true
            }
        }
        
        if let consumedCals = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) {
            if !consumedCalsIsLoading {
                getCalorieStatsCollectionForWeek(using: consumedCals)
                consumedCalsIsLoading = true
            }
        }
        
        //        Healthkit appears to be way overestimating basal energy, so replacing with the information returned from backend for now.
        //        if let basalCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned) {
        //            self.getCalorieStatsCollectionForWeek(using: basalCalsBurned)
        //        }
    }
    
    func updateBodyCompStats() {
        if let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            getBodyCompStatsForLast30Days(using: weightSampleType)
        }
        
        if let bodyFatSampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) {
            getBodyCompStatsForLast30Days(using: bodyFatSampleType)
        }
    }
    
    func updateAllCalorieData() {
        if let activeCalsBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            getCalorieStatsCollectionForWeek(using: activeCalsBurned)
        }
        
        if let consumedCals = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) {
            getCalorieStatsCollectionForWeek(using: consumedCals)
        }
    }
    
    var currentWeight: Double? {
        didSet {
            NotificationCenter.default.post(name: .currentWeightUpdated, object: nil)
        }
    }
    
    var noData: Bool {
        if noActiveCalsData && noConsumedCalsData && noWeightData && noBodyFatData {
            return true
        }
        return false
    }
    
    var noActiveCalsData: Bool = true
    var noConsumedCalsData: Bool = true
    var noWeightData = true
    var noBodyFatData = true
    
    var activeCalories = Calories()
    
    var consumedCalories = Calories()
    
    var todaysCalorieConsumption = DailyMacros()
    
    var caloricDeficits = Calories()
    
    var weight = Weight()
    
    var bodyFat = Weight()
    
    var isLoading: Bool {
        if activeCalsIsLoading || consumedCalsIsLoading || weightIsLoading || bodyFatIsLoading {
            return true
        }
        return false
    }
    
    var activeCalsIsLoading: Bool = false
    var consumedCalsIsLoading: Bool = false
    var weightIsLoading: Bool = false
    var bodyFatIsLoading: Bool = false
    
    
    // MARK: - Manual Calculations
    
    private func calculateCaloricDeficits(with caloricBudget: Int) {
        guard caloricBudget > 0, consumedCalories.allDataIsLoaded else { return }
        
        let deficitDay1 = consumedCalories.day1Count == 0 ? 0 : caloricBudget - consumedCalories.day1Count
        let deficitDay2 = consumedCalories.day2Count == 0 ? 0 : caloricBudget - consumedCalories.day2Count
        let deficitDay3 = consumedCalories.day3Count == 0 ? 0 : caloricBudget - consumedCalories.day3Count
        let deficitDay4 = consumedCalories.day4Count == 0 ? 0 : caloricBudget - consumedCalories.day4Count
        let deficitDay5 = consumedCalories.day5Count == 0 ? 0 : caloricBudget - consumedCalories.day5Count
        let deficitDay6 = consumedCalories.day6Count == 0 ? 0 : caloricBudget - consumedCalories.day6Count
        let deficitDay7 = consumedCalories.day7Count == 0 ? 0 : caloricBudget - consumedCalories.day7Count
        
        caloricDeficits.day1Label = consumedCalories.day1Label
        caloricDeficits.day1Count = deficitDay1
        
        caloricDeficits.day2Label = consumedCalories.day2Label
        caloricDeficits.day2Count = deficitDay2
        
        caloricDeficits.day3Label = consumedCalories.day3Label
        caloricDeficits.day3Count = deficitDay3
        
        caloricDeficits.day4Label = consumedCalories.day4Label
        caloricDeficits.day4Count = deficitDay4
        
        caloricDeficits.day5Label = consumedCalories.day5Label
        caloricDeficits.day5Count = deficitDay5
        
        caloricDeficits.day6Label = consumedCalories.day6Label
        caloricDeficits.day6Count = deficitDay6
        
        caloricDeficits.day7Label = consumedCalories.day7Label
        caloricDeficits.day7Count = deficitDay7
        
        caloricDeficits.totalSum = deficitDay1 + deficitDay2 + deficitDay3 + deficitDay4 + deficitDay5 + deficitDay6 + deficitDay7
    }
    
    private func stopLoadingFor(sampleType: HKSampleType) {
        if sampleType == HKSampleType.quantityType(forIdentifier: .bodyMass) {
            self.weightIsLoading = false
        }
        
        if sampleType == HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) {
            self.bodyFatIsLoading = false
        }
        
        return
    }
    
    private func stopLoadingFor(quantityType: HKQuantityType) {
        if quantityType == HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            self.activeCalsIsLoading = false
        }
        
        if quantityType == HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) {
            self.consumedCalsIsLoading = false
        }
    }
    
    // MARK: - HealthKit Data Fetching Functionality
    
    private func getBodyCompStatsForLast30Days(using sampleType: HKSampleType) {
        let endDate = Date()
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -29, to: endDate) else {
            print("error getting start date for statistics collection")
            stopLoadingFor(sampleType: sampleType)
            return
        }
        
        getMostRecentSamples(for: sampleType, withStart: startDate, limit: 100) { (samples, error) in
            if let error = error {
                print("Error getting weight samples for health dashboard: \(error)")
                self.stopLoadingFor(sampleType: sampleType)
                return
            }
            
            guard let samples = samples else {
                self.stopLoadingFor(sampleType: sampleType)
                return
            }
            
            switch sampleType.identifier {
            case HKQuantityTypeIdentifier.bodyMass.rawValue:
                
                self.weight.weightReadings = []
                self.weight.rateChange = 0
                
                for item in samples {
                    let weight = item.quantity.doubleValue(for: HKUnit.pound()).roundToDecimal(1)
                    self.weight.weightReadings.append(weight)
                }
                
                if let mostRecent = self.weight.weightReadings.last {
                    self.currentWeight = mostRecent
                }
                
                if let inital = self.weight.weightReadings.first, let mostRecent = self.weight.weightReadings.last {
                    var difference = mostRecent - inital
                    difference = (difference / inital) * 100
                    let rateChange = difference.roundToDecimal(2)
                    self.weight.rateChange = rateChange
                }
                
                if !self.weight.weightReadings.isEmpty {
                    self.noWeightData = false
                }
                
                self.stopLoadingFor(sampleType: sampleType)
                
            case HKQuantityTypeIdentifier.bodyFatPercentage.rawValue:
                
                self.bodyFat.weightReadings = []
                self.bodyFat.rateChange = 0
                
                for item in samples {
                    // HealthKit returns body fat percent as a decimal
                    let bodyFatDecimal = item.quantity.doubleValue(for: HKUnit.percent()).roundToDecimal(4)
                    let bodyFat = bodyFatDecimal * 100
                    self.bodyFat.weightReadings.append(bodyFat)
                }
                
                if let inital = self.bodyFat.weightReadings.first, let mostRecent = self.bodyFat.weightReadings.last {
                    let difference = mostRecent - inital
                    let rateChange = difference.roundToDecimal(2)
                    self.bodyFat.rateChange = rateChange
                }
                
                if !self.bodyFat.weightReadings.isEmpty {
                    self.noBodyFatData = false
                }
                
                self.stopLoadingFor(sampleType: sampleType)
                
            default:
                self.stopLoadingFor(sampleType: sampleType)
                return
            }
        }
    }
    
    private func getCalorieStatsCollectionForWeek(using quantityType: HKQuantityType) {
        getCumulativeStatsCollectionUsingOneDayInterval(for: quantityType) { (statsCollection, error) in
            if let error = error {
                print(error)
                self.stopLoadingFor(quantityType: quantityType)
                return
            }
            
            guard let statsCollection = statsCollection else {
                print("error with stats collection data")
                self.stopLoadingFor(quantityType: quantityType)
                return
            }
            
            let endDate = Date()
            
            guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: endDate) else {
                print("error getting start date for statistics collection")
                self.stopLoadingFor(quantityType: quantityType)
                return
            }
            
            var caloriesByDay: [(String, Int)] = []
            
            // Will be used to calculate average calories for week ignoring the current date as still in progress
            var weeklyCalorieSum = 0
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                
                // If sumQuantity is nil, the calories for the day will be set to 0
                var calories = 0
                
                if let caloriesSum = statistics.sumQuantity() {
 
                    let calorieDouble = caloriesSum.doubleValue(for: HKUnit.kilocalorie())
                    let calorieInt = Int(calorieDouble)
                    
                    calories = calorieInt
                }
                
                let date = statistics.startDate
                let weekDay = Calendar.current.component(.weekday, from: date)
                
                let dateFormatter = DateFormatter()
                let weekDayString = dateFormatter.weekdaySymbols[weekDay - 1]
                
                caloriesByDay.append((weekDayString, calories))
                
                weeklyCalorieSum += calories
            }
            
            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
                self.activeCalories.average = weeklyCalorieSum / 7
                
                self.activeCalories.day1Label = caloriesByDay[0].0
                self.activeCalories.day1Count = caloriesByDay[0].1
                
                self.activeCalories.day2Label = caloriesByDay[1].0
                self.activeCalories.day2Count = caloriesByDay[1].1
                
                self.activeCalories.day3Label = caloriesByDay[2].0
                self.activeCalories.day3Count = caloriesByDay[2].1
                
                self.activeCalories.day4Label = caloriesByDay[3].0
                self.activeCalories.day4Count = caloriesByDay[3].1
                
                self.activeCalories.day5Label = caloriesByDay[4].0
                self.activeCalories.day5Count = caloriesByDay[4].1
                
                self.activeCalories.day6Label = caloriesByDay[5].0
                self.activeCalories.day6Count = caloriesByDay[5].1
                
                self.activeCalories.day7Label = caloriesByDay[6].0
                self.activeCalories.day7Count = caloriesByDay[6].1
                
                if weeklyCalorieSum != 0 {
                    self.noActiveCalsData = false
                }
                
                self.stopLoadingFor(quantityType: quantityType)
                //                Temporarily using the data returned from back end for the daily calorie budget instead of basal energy
                //            case HKQuantityTypeIdentifier.basalEnergyBurned.rawValue:
                //                self.basalCalories = caloriesByDay
                
            case HKQuantityTypeIdentifier.dietaryEnergyConsumed.rawValue:
                self.consumedCalories.average = weeklyCalorieSum / 7
                
                self.consumedCalories.day1Label = caloriesByDay[0].0
                self.consumedCalories.day1Count = caloriesByDay[0].1
                
                self.consumedCalories.day2Label = caloriesByDay[1].0
                self.consumedCalories.day2Count = caloriesByDay[1].1
                
                self.consumedCalories.day3Label = caloriesByDay[2].0
                self.consumedCalories.day3Count = caloriesByDay[2].1
                
                self.consumedCalories.day4Label = caloriesByDay[3].0
                self.consumedCalories.day4Count = caloriesByDay[3].1
                
                self.consumedCalories.day5Label = caloriesByDay[4].0
                self.consumedCalories.day5Count = caloriesByDay[4].1
                
                self.consumedCalories.day6Label = caloriesByDay[5].0
                self.consumedCalories.day6Count = caloriesByDay[5].1
                
                self.consumedCalories.day7Label = caloriesByDay[6].0
                self.consumedCalories.day7Count = caloriesByDay[6].1
                
                self.consumedCalories.allDataIsLoaded = true
                
                if weeklyCalorieSum != 0 {
                    self.noConsumedCalsData = false
                }
                
                let usersCaloricBudget = UserDefaults.standard.integer(forKey: UserDefaults.Keys.caloricBudget.rawValue)
                
                self.calculateCaloricDeficits(with: usersCaloricBudget)
                
                if usersCaloricBudget > 0 {
                    let todaysCount = self.consumedCalories.day7Count
                    let progressPercent = (Double(todaysCount) / Double(usersCaloricBudget)) * 100
                    self.todaysCalorieConsumption.caloriesCount = CGFloat(todaysCount)
                    self.todaysCalorieConsumption.caloriesPercent = CGFloat(progressPercent)
                }
                
                self.stopLoadingFor(quantityType: quantityType)
            default:
                self.stopLoadingFor(quantityType: quantityType)
                return
            }
        }
    }
    
    
    // MARK: - HealthKit Interfacing Methods
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitError.dataNotAvailable)
            return
        }
        
        guard let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let basalEnergy = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
            let energyConsumed = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
            let carbs = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
            let fat = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
            let protein = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
            let weight = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let bodyFat = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage) else {
                completion(false, HealthKitError.missingInformation)
                return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [energyConsumed, carbs, fat, protein]
        
        let healthKitTypesToRead: Set<HKObjectType> = [activeEnergy, basalEnergy, energyConsumed, carbs, fat, protein, weight, bodyFat]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    func saveCalorieIntakeSample(calories: Double) {
        guard let consumedCaloriesType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Error with calorie intake save method")
            return
        }
        
        let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
        
        let calorieSample = HKQuantitySample(type: consumedCaloriesType, quantity: calorieQuantity, start: Date(), end: Date())
        
        HKHealthStore().save(calorieSample) { (success, error) in
            if let error = error {
                print("Error saving consumed calorie data to healthkit: \(error)")
            } else {
                print("Successfully saved calorie data to healthkit")
            }
        }
    }
    
    func getMostRecentSamples(for sampleType: HKSampleType, withStart date: Date = Date.distantPast, limit: Int = 1, sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true), completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: .strictEndDate)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples else {
                                                    completion(nil, error)
                                                    return
                                                }
                                                
                                                if let quantitySamples = samples as? [HKQuantitySample] {
                                                    completion(quantitySamples, nil)
                                                }
                                            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    func getCumulativeSamples(for quantityType: HKQuantityType, startDate: Date = Date(), endDate: Date = Date(), options: HKStatisticsOptions = [], completion: @escaping (HKStatistics?, Error?) -> Void) {
        var allSamplesForDatePredicate = NSPredicate()
        let startOfFirstDay = Calendar.current.startOfDay(for: startDate)
        
        // Conditionally set the start/end time for date range
        if Calendar.current.isDateInToday(endDate) {
            // If the end date is today, get all readings up till this point in time for today
            allSamplesForDatePredicate = HKQuery.predicateForSamples(withStart: startOfFirstDay, end: endDate, options: .strictEndDate)
        } else {
            // Else use the maximum possible time for the end date to get all readings
            let endOfLastDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)
            allSamplesForDatePredicate = HKQuery.predicateForSamples(withStart: startOfFirstDay, end: endOfLastDay, options: .strictEndDate)
        }
        
        let cumulativeQuery = HKStatisticsQuery(quantityType: quantityType,
                                                quantitySamplePredicate: allSamplesForDatePredicate,
                                                options: options) { (_, stats, error) in
                                                    DispatchQueue.main.async {
                                                        guard let stats = stats else {
                                                            print("Error getting health kit statistics query result")
                                                            completion(nil, error)
                                                            return
                                                        }
                                                        
                                                        completion(stats, nil)
                                                    }
        }
        HKHealthStore().execute(cumulativeQuery)
    }
    
    
    func getCumulativeStatsCollectionUsingOneDayInterval(for quantityType: HKQuantityType, options: HKStatisticsOptions = [], completion: @escaping (HKStatisticsCollection?, Error?) -> Void) {
        
        var interval = DateComponents()
        interval.day = 1
        
        let anchorDate = Calendar.current.startOfDay(for: Date())
        
        let cumulativeCollectionQuery = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        cumulativeCollectionQuery.initialResultsHandler = { query, results, error in
            if let error = error {
                print("Error with collections query: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let statsCollection = results else {
                print("Failed to get collection query results")
                DispatchQueue.main.async {
                    completion(nil, HealthKitError.generalQueryError)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(statsCollection, nil)
            }
        }
        
        HKHealthStore().execute(cumulativeCollectionQuery)
    }
    
}
