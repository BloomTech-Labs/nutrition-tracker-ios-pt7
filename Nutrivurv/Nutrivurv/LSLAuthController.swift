//
//  LSLAuthController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import KeychainSwift

class AuthController {
    static let shared = AuthController()
    
    static let authKeychainToken = "authorizationToken"
    let keychain = KeychainSwift()
    
    private let baseURL = URL(string: "https://nutrivurv-be.herokuapp.com/api/auth")!
    
    func loginUser(user: userREST, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
    }
    
    func registerUser(user: userREST, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let registerURL = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: registerURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            print("Error encoding user data for registration")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error registering user: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                    return
                }
            }
            
            guard let data = data else {
                print("Error getting data from server")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                if let token = authResponse.token {
                    self.keychain.set(token, forKey: AuthController.authKeychainToken)
                } else {
                    print("Error saving token in keychain")
                }
            } catch {
                print("Error decoding registration response data")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            completion(.success(true))
            
        }.resume()
    }
    
}
