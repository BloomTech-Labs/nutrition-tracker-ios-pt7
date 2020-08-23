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
    
    // Object used to publish value for activity rings and total macros view on user dashboard
    @ObservedObject var totalDailyMacrosModel = DailyMacros()
    
    // Separate individual objects for each meal to be used in the food log tableview header sections
    @ObservedObject var breakfastMacrosModel = DailyMacros()
    @ObservedObject var lunchMacrosModel = DailyMacros()
    @ObservedObject var dinnerMacrosModel = DailyMacros()
    @ObservedObject var snacksMacrosModel = DailyMacros()
    
    var foodLog: FoodLog? {
        didSet {
            parseFoodLogEntries()
        }
    }
    
    var selectedDate: Date? {
        didSet {
            NotificationCenter.default.post(name: .selectedDateChanged, object: selectedDate)
            // add observor to food log table view
        }
    }
    
    func setNewSelectedDate(_ date: Date) {
        totalDailyMacrosModel.resetMacros()
        self.selectedDate = date
    }
    
    
    // MARK: - Calculating Macros
    
    func parseFoodLogEntries() {
        guard let foodLog = foodLog else { return }
        
        var totalMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        var breakfastMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var lunchMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var dinnerMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var snacksMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
//        var waterMacros: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0) // TODO: Water is a future release feature
        
        if let breakfast = foodLog.breakfast {
            breakfastMacros = getMacrosTuple(for: breakfast)
            
            DispatchQueue.main.async {
                self.breakfastMacrosModel.caloriesCount = breakfastMacros.0
                self.breakfastMacrosModel.carbsCount = breakfastMacros.1
                self.breakfastMacrosModel.proteinCount = breakfastMacros.2
                self.breakfastMacrosModel.fatCount = breakfastMacros.3
            }
        }
        
        if let lunch = foodLog.lunch {
            lunchMacros = getMacrosTuple(for: lunch)
            
            DispatchQueue.main.async {
                self.lunchMacrosModel.caloriesCount = lunchMacros.0
                self.lunchMacrosModel.carbsCount = lunchMacros.1
                self.lunchMacrosModel.proteinCount = lunchMacros.2
                self.lunchMacrosModel.fatCount = lunchMacros.3
            }
        }
        
        if let dinner = foodLog.dinner {
            dinnerMacros = getMacrosTuple(for: dinner)
            
            DispatchQueue.main.async {
                self.dinnerMacrosModel.caloriesCount = dinnerMacros.0
                self.dinnerMacrosModel.carbsCount = dinnerMacros.1
                self.dinnerMacrosModel.proteinCount = dinnerMacros.2
                self.dinnerMacrosModel.fatCount = dinnerMacros.3
            }
        }
        
        if let snacks = foodLog.snack {
            snacksMacros = getMacrosTuple(for: snacks)
            
            DispatchQueue.main.async {
                self.snacksMacrosModel.caloriesCount = snacksMacros.0
                self.snacksMacrosModel.carbsCount = snacksMacros.1
                self.snacksMacrosModel.proteinCount = snacksMacros.2
                self.snacksMacrosModel.fatCount = snacksMacros.3
            }
        }
        
        // TODO: Water is a future release feature
//        if let water = foodLog.water {
//            let waterMacros = getMacrosTuple(for: water)
//        }
        
        for i in 0...3 {
            switch i {
            case 0:
                totalMacros.0 = breakfastMacros.0 + lunchMacros.0 + dinnerMacros.0 + snacksMacros.0 // + waterMacros.0
            case 1:
                totalMacros.1 = breakfastMacros.1 + lunchMacros.1 + dinnerMacros.1 + snacksMacros.1 // + waterMacros.1
            case 2:
                totalMacros.2 = breakfastMacros.2 + lunchMacros.2 + dinnerMacros.2 + snacksMacros.2 // + waterMacros.2
            case 3:
                totalMacros.3 = breakfastMacros.3 + lunchMacros.3 + dinnerMacros.3 + snacksMacros.3 // + waterMacros.3
            default:
                continue
            }
        }
        
        DispatchQueue.main.async {
            // Directly setting values of the observed object to update dashboard accordingly
            self.totalDailyMacrosModel.caloriesCount = totalMacros.0
            if totalMacros.0 > 1 {
                // TODO: make 2775 an enviroment object (or use User Defaults) to change pct calculations based on user settings.
                if let caloriesBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.caloricBudget) as? CGFloat {
                    self.totalDailyMacrosModel.caloriesPercent = (totalMacros.0 / caloriesBudget) * 100
                }
            }
            
            self.totalDailyMacrosModel.carbsCount = totalMacros.1
            if totalMacros.1 > 1 {
                if let carbsBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.carbsBudget) as? CGFloat {
                    self.totalDailyMacrosModel.carbsPercent = (totalMacros.1 / carbsBudget) * 100
                }
            }
            
            
            self.totalDailyMacrosModel.proteinCount = totalMacros.2
            if totalMacros.2 > 1 {
                if let proteinBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.proteinBudget) as? CGFloat {
                        self.totalDailyMacrosModel.proteinPercent = (totalMacros.2 / proteinBudget) * 100
                }
            }
            
            
            self.totalDailyMacrosModel.fatCount = totalMacros.3
            if totalMacros.3 > 1 {
                if let fatBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.fatBudget) as? CGFloat {
                    self.totalDailyMacrosModel.fatPercent = (totalMacros.3 / fatBudget) * 100
                }
            }
        }
    }
    
    private func getMacrosTuple(for meal: [FoodLogEntry]) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var totalCalories: CGFloat = 0.0
        var totalCarbs: CGFloat = 0.0
        var totalProtein: CGFloat = 0.0
        var totalFat: CGFloat = 0.0
        
        for entry in meal {
            totalCalories += CGFloat(entry.calories)
            
            if let carbs = entry.carbs.getCGFloatfromString() {
                totalCarbs += carbs
            }
            
            if let protein = entry.protein.getCGFloatfromString() {
                totalProtein += protein
            }
            
            if let fat = entry.fat.getCGFloatfromString() {
                totalFat += fat
            }
        }
        
        return (totalCalories, totalCarbs, totalProtein, totalFat)
    }
    
    
    
    // MARK: - FoodLogEntry CRUD and Networking Methods
    
    func createFoodLogEntry(entry: FoodLogEntry, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let token = getUserToken() else {
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
    
    func editFoodLogEntry(entry: FoodLogEntry, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let token = getUserToken() else {
            print("No token found for user")
            DispatchQueue.main.async {
                completion(.failure(.noAuth))
            }
            return
        }
        
        guard let entryID = entry.id else {
            print("Unable to update entry: no ID associated with entry")
            DispatchQueue.main.async {
                completion(.failure(.otherError))
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("\(entryID)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                print("Error updating food log entry: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
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
                    print("Unable to edit food log entry. Server response error: \(response.statusCode)")
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
    
    func getFoodLogEntriesForDate(date: String, completion: @escaping (Result<FoodLog?, NetworkError>) -> Void) {
        guard let token = getUserToken() else {
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
                if response.statusCode == 401 {
                    // User token is expired
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
                    return
                }
                
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
    
    
    func deleteFoodLogEntry(entry: FoodLogEntry, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let token = getUserToken() else {
            print("No token found for user")
            DispatchQueue.main.async {
                completion(.failure(.noAuth))
            }
            return
        }
        
        guard let entryID = entry.id else {
            print("Unable to update entry: no ID associated with entry")
            DispatchQueue.main.async {
                completion(.failure(.otherError))
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("\(entryID)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
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
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
            
        }.resume()
    }
    
    
    // MARK: - Helper Functions
    
    private func getUserToken() -> String? {
        guard let token = UserController.keychain.get(UserController.authKeychainToken) else {
            return nil
        }
        return token
    }
    
}
