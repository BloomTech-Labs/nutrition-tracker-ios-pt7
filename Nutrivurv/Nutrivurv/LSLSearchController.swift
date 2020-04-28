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
    
    func searchForFoodItem(searchTerm: String, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let appIdQueryItem = URLQueryItem(name: "app_id", value: appId)
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: appKey)
        let searchTermQueryItem = URLQueryItem(name: "ingr", value: searchTerm)

        urlComponents?.queryItems = [appIdQueryItem, appKeyQueryItem, searchTermQueryItem]

        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(); return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion()
                return
            }

            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let foodSearch = try jsonDecoder.decode(FoodSearch.self, from: data)
                self.foods = foodSearch.hints
            } catch {
                NSLog("Unable to decode data into object of type FoodSearch: \(error)")
            }

            completion()
        }.resume()
    }
    
    func searchForNutrients(qty: Int, measure: String, foodId: String, completion: @escaping () -> Void) {
        let json: [String: Any] = ["ingredients": ["quantity": qty,
                                   "measureURI": measure,
                                   "foodId": foodId]]
        print("JSON Object: \(json)")
        
        var urlComponents = URLComponents(url: nutritionURL, resolvingAgainstBaseURL: true)
        let appIdQueryItem = URLQueryItem(name: "app_id", value: appId)
        let appKeyQueryItem = URLQueryItem(name: "app_key", value: appKey)

        urlComponents?.queryItems = [appIdQueryItem, appKeyQueryItem]

        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(); return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print("Error adding httpBody: \(error.localizedDescription)")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion()
                return
            }

            guard let data = data else { NSLog("No data returned from data task"); completion(); return }

            let jsonDecoder = JSONDecoder()
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let nutrients = try jsonDecoder.decode(Nutrients.self, from: data)
                self.nutrients = nutrients
            } catch {
                NSLog("Unable to decode data into object of type Nutrients: \(error)")
            }

            completion()
        }.resume()
    }
    
}
