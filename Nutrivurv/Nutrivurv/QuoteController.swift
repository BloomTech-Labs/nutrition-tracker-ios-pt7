//
//  QuoteController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class QuoteController {
    static let shared = QuoteController()
    private let baseURL = URL(string: "https://api.quotable.io/random")!
    
    func getRandomQuote(completion: @escaping (Result<Quote, NetworkError>) -> Void) {
        
        var urlComponets = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponets?.queryItems = [
            URLQueryItem(name: "maxLength", value: "100"),
             URLQueryItem(name: "tags", value: "inspirational|life|happiness")
        ]
        
        guard let url = urlComponets?.url else {
            print("Couldn't generate quote api url from url components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching quote request: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                print("Error getting qoute data")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let quote = try decoder.decode(Quote.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(quote))
                }
            } catch {
                print("Error decoding quote data")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
            
        }.resume()
        
    }
}
