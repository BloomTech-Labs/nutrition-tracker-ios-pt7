//
//  LSLSearchController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class LSLSearchController {
    
    var foods: [FoodItem] = []
    var nutrients: Nutrients?
    
    let appId = "f3679250"
    let appKey = "ffb42eb1e4e177b64d6f5f5c94c764b5"
    let baseURL = URL(string: "https://api.edamam.com/api/food-database/parser")!
    let nutritionURL = URL(string: "https://api.edamam.com/api/food-database/nutrients")!
    
    func searchForFoodItemWithKeyword(searchTerm: String, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let appIdQueryItem = URLQueryItem(name: "app_id", value: appId)
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: appKey)
        let searchTermQueryItem = URLQueryItem(name: "ingr", value: searchTerm)

        urlComponents?.queryItems = [appIdQueryItem, appKeyQueryItem, searchTermQueryItem]

        guard let requestURL = urlComponents?.url else {
            NSLog("requestURL is nil")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            guard let data = data else {
                NSLog("No data returned from data task")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let foodSearch = try jsonDecoder.decode(FoodSearch.self, from: data)
                self.foods = foodSearch.hints
            } catch {
                NSLog("Unable to decode data into object of type FoodSearch: \(error)")
            }

            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    func searchForFoodItemWithUPC(searchTerm: String, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let appIdQueryItem = URLQueryItem(name: "app_id", value: appId)
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: appKey)
        let searchTermQueryItem = URLQueryItem(name: "upc", value: searchTerm)

        urlComponents?.queryItems = [appIdQueryItem, appKeyQueryItem, searchTermQueryItem]

        guard let requestURL = urlComponents?.url else {
            NSLog("requestURL is nil")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            guard let data = data else {
                NSLog("No data returned from data task")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let foodSearch = try jsonDecoder.decode(FoodSearch.self, from: data)
                self.foods = foodSearch.hints
            } catch {
                NSLog("Unable to decode data into object of type FoodSearch: \(error)")
            }

            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    
    
    func searchForNutrients(qty: Double, measure: String, foodId: String, completion: @escaping (Nutrients?) -> Void) {
        let json: [String: Any] = ["ingredients": [["quantity": qty, "measureURI": measure, "foodId": foodId]]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var urlComponents = URLComponents(url: nutritionURL, resolvingAgainstBaseURL: true)
        let appIdQueryItem = URLQueryItem(name: "app_id", value: appId)
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: appKey)

        urlComponents?.queryItems = [appIdQueryItem, appKeyQueryItem]

        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(nil); return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = jsonData
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching nutrient data: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data else {
                NSLog("No nutrient data returned from data task")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            var nutrients: Nutrients?
            
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                nutrients = try jsonDecoder.decode(Nutrients.self, from: data)
            } catch {
                NSLog("Unable to decode data into object of type Nutrients: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nutrients)
            }
        }.resume()
    }
}
