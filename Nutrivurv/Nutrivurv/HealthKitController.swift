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
    
    class func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                
                guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
                    completion(nil, error)
                    return
                }
                
                completion(mostRecentSample, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}
