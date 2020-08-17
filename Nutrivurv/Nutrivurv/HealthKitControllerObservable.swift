//
//  HealthKitControllerObservable.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import HealthKit


class HealthKitControllerObservable: ObservableObject {
    
    static let shared = HealthKitControllerObservable()
    
    public init() {
        if let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            getBodyCompStatsForLast30Days(using: weightSampleType)
        }

        if let bodyFatSampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) {
            getBodyCompStatsForLast30Days(using: bodyFatSampleType)
        }
    }
    
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
    
    var weight = Weight()
    
    var bodyFat = Weight()
    
    
    // MARK: - HealthKit Data Fetching Functionality
    
    private func getBodyCompStatsForLast30Days(using sampleType: HKSampleType) {
        let endDate = Date()
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -29, to: endDate) else {
            print("error getting start date for statistics collection")
            return
        }
        
        HealthKitController.getMostRecentSamples(for: sampleType, withStart: startDate, limit: 100) { (samples, error) in
            if let error = error {
                print("Error getting weight samples for health dashboard: \(error)")
                return
            }
            
            guard let samples = samples else {
                return
            }

            switch sampleType.identifier {
            case HKQuantityTypeIdentifier.bodyMass.rawValue:
                
                for item in samples {
                    let weight = item.quantity.doubleValue(for: HKUnit.pound()).roundToDecimal(1)
                    self.weight.weightReadings.append(weight)
                }
                
                if let inital = self.weight.weightReadings.first, let mostRecent = self.weight.weightReadings.last {
                    var difference = mostRecent - inital
                    difference = (difference / inital) * 100
                    let rateChange = difference.roundToDecimal(2)
                    self.weight.rateChange = rateChange
                }
                
            case HKQuantityTypeIdentifier.bodyFatPercentage.rawValue:
                
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
                
            default:
                return
            }
        }
    }
    
    
    // MARK: - HealthKit Interfacing Methods
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
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
    
    class func saveCalorieIntakeSample(calories: Double) {
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
    
    class func getMostRecentSamples(for sampleType: HKSampleType, withStart date: Date = Date.distantPast, limit: Int = 1, completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
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
    
    class func getCumulativeSamples(for quantityType: HKQuantityType, startDate: Date = Date(), endDate: Date = Date(), options: HKStatisticsOptions = [], completion: @escaping (HKStatistics?, Error?) -> Void) {
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
    
    
    class func getCumulativeStatsCollectionUsingOneDayInterval(for quantityType: HKQuantityType, options: HKStatisticsOptions = [], completion: @escaping (HKStatisticsCollection?, Error?) -> Void) {
    
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
