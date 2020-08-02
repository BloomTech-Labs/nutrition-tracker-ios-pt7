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
    
    var foodLog = FoodLog()
    
    func foodLogIsEmpty() -> Bool {
        return foodLog.breakfast == nil && foodLog.lunch == nil && foodLog.dinner == nil && foodLog.snack == nil && foodLog.water == nil
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
            var foodLog = FoodLog()
            
            do {
                let foodLogResponse = try decoder.decode(FoodLogResponse.self, from: data)
                foodLog = foodLogResponse.meals
            } catch {
                print("Error decoding food log from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            print(foodLog)
            DispatchQueue.main.async {
                completion(.success(foodLog))
            }
        }.resume()
    }
    
    
    func deleteFoodLogEntry() {
        // DELETE
    }
    
}
