//
//  HealthKitController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitController {
    
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
            let weight = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
                  completion(false, HealthKitError.missingInformation)
                  return
              }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [energyConsumed, carbs, fat, protein]
        
        let healthKitTypesToRead: Set<HKObjectType> = [activeEnergy, basalEnergy, energyConsumed, carbs, fat, protein, weight]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    class func getMostRecentSample(for sampleType: HKSampleType, withStart date: Date = Date.distantPast, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                
                guard let samples = samples else {
                    completion(nil, error)
                    return
                }
                
               
                if let mostRecentSample = samples.first as? HKQuantitySample {
                     completion(mostRecentSample, nil)
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
    
    
}
