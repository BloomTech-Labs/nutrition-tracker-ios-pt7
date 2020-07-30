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
    
    
    let defaultMealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    var foodLog: [FoodLogEntry] = []
    
    
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
    
    func getFoodLogEntriesForDate() {
        // GET
    }
    
    func deleteFoodLogEntry() {
        // DELETE
    }
    
}
