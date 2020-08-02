//
//  FoodLogController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import KeychainSwift

class FoodLogController {
    static let shared = FoodLogController()
    
    private let baseURL = URL(string: "https://nutrivurv-be.herokuapp.com/api/log")!
    
    @ObservedObject var dailyMacrosModel = DailyMacros()
    
    // Each of these macros below communicate via Combine with SwiftUI to update activity and macros view
    var caloriesCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.caloriesCount = caloriesCount
        }
    }
    
    var caloriesPct: CGFloat = 0.005 {
        didSet {
            dailyMacrosModel.caloriesPercent = caloriesPct
        }
    }
    
    var carbsCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.carbsCount = carbsCount
        }
    }
    
    var carbsPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.carbsPercent = carbsPct
           }
       }
    
    var proteinCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.proteinCount = proteinCount
        }
    }
    
    var proteinPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.proteinPercent = proteinPct
           }
       }
    
    var fatCount: CGFloat = 0.0 {
        didSet {
            dailyMacrosModel.fatCount = fatCount
        }
    }
    
    var fatPct: CGFloat = 0.005 {
           didSet {
               dailyMacrosModel.fatPercent = fatPct
           }
       }
    
    var foodLog: FoodLog? {
        didSet {
            parseFoodLogEntries()
        }
    }
    
    // MARK: - Calculating Macros
    
    func parseFoodLogEntries() {
        guard let foodLog = foodLog else { return }
        
        var totalMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        var breakfastMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var lunchMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var dinnerMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var snacksMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var waterMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        if let breakfast = foodLog.breakfast {
            breakfastMacros = getMacrosTuple(for: breakfast)
        }
        
        if let lunch = foodLog.lunch {
            lunchMacros = getMacrosTuple(for: lunch)
        }
        
        if let dinner = foodLog.dinner {
            dinnerMacros = getMacrosTuple(for: dinner)
        }
        
        if let snacks = foodLog.snack {
            snacksMacros = getMacrosTuple(for: snacks)
        }
        
        if let water = foodLog.water {
            waterMacros = getMacrosTuple(for: water)
        }
        
        for i in 0...3 {
            switch i {
            case 0:
                totalMacros.0 = breakfastMacros.0 + lunchMacros.0 + dinnerMacros.0 + snacksMacros.0 + waterMacros.0
            case 1:
                totalMacros.1 = breakfastMacros.1 + lunchMacros.1 + dinnerMacros.1 + snacksMacros.1 + waterMacros.1
            case 2:
                totalMacros.2 = breakfastMacros.2 + lunchMacros.2 + dinnerMacros.2 + snacksMacros.2 + waterMacros.2
            case 3:
                totalMacros.3 = breakfastMacros.3 + lunchMacros.3 + dinnerMacros.3 + snacksMacros.3 + waterMacros.3
            default:
                continue
            }
        }
        
        DispatchQueue.main.async {
            self.caloriesCount = totalMacros.0
            self.carbsCount = totalMacros.1
            self.proteinCount = totalMacros.2
            self.fatCount = totalMacros.3
            
            if self.caloriesCount > 1 {
                self.caloriesPct = (self.caloriesCount / 2775) * 100
            }
            
            if self.carbsCount > 1 {
                self.carbsPct = (self.carbsCount / 40) * 100
            }
            
            if self.proteinCount > 1 {
                self.proteinPct = (self.proteinCount / 170) * 100
            }
            
            if self.fatCount > 1 {
                 self.fatPct = (self.fatCount / 215) * 100
            }
        }
    }
    
    private func getMacrosTuple(for meal: [FoodLogEntry]) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var totalCalories = 0.0
        var totalCarbs = 0.0
        var totalProtein = 0.0
        var totalFat = 0.0
        
        for entry in meal {
            totalCalories += Double(entry.calories)
            
            if let carbs = Double(entry.carbs.getNumbersfromString()) {
                totalCarbs += carbs
            }
            
            if let protein = Double(entry.protein.getNumbersfromString()) {
                totalProtein += protein
            }
            
            if let fat = Double(entry.fat.getNumbersfromString()) {
                totalFat += fat
            }
        }
        
        return (CGFloat(totalCalories), CGFloat(totalCarbs), CGFloat(totalProtein), CGFloat(totalFat))
    }
    
    
    
    // MARK: - FoodLogEntry CRUD and Networking Methods
    
    func createFoodLogEntry(entry: FoodLogEntry, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let token = UserAuthController.keychain.get(UserAuthController.authKeychainToken) else {
            print("No token found for user")
            DispatchQueue.main.async {
                completion(.failure(.noAuth))
            }
            return
        }
        
        var request = URLRequest(url: baseURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(entry)
            request.httpBody = data
        } catch {
            print("Error encoding food item for upload to database: \(error)")
            DispatchQueue.main.async {
                completion(.failure(NetworkError.noEncode))
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error occured with food entry data task: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.otherError))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 401 {
                    print("Token no longer valid; please re-login")
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
                    return
                } else if response.statusCode != 201 {
                    print("Unable to upload food entry. Server response error: \(response.statusCode)")
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.serverError))
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func editFoodLogEntry() {
        // PUT
    }
    
    func getFoodLogEntriesForDate(date: String, completion: @escaping (Result<FoodLog?, NetworkError>) -> Void) {
        // GET
        guard let token = UserAuthController.keychain.get(UserAuthController.authKeychainToken) else {
            print("No token found for user")
            DispatchQueue.main.async {
                completion(.failure(.noAuth))
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("date/\(date)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with get food log for date data task: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error communicating with server. Response information: \(response), status code: \(response.statusCode)")
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
                    }
                    return
                }
            }
            
            guard let data = data else {
                print("Error with data received for food log")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            var tempFoodLog = FoodLog()
            
            do {
                let foodLogResponse = try decoder.decode(FoodLogResponse.self, from: data)
                tempFoodLog = foodLogResponse.meals
                self.foodLog = tempFoodLog
            } catch {
                print("Error decoding food log from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(tempFoodLog))
            }
        }.resume()
    }
    
    
    func deleteFoodLogEntry() {
        // DELETE
    }
    
}
