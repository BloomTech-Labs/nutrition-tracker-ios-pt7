//
//  AuthController.swift
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
    static let keychain = KeychainSwift()
    
    private let baseURL = URL(string: "https://nutrivurv-be.herokuapp.com/api/auth")!
    
    func loginUser(user: userREST, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: loginURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            print("Error encoding user for login")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error logging in user: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    // Incorrect password
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
                    return
                }
            }
            
            guard let data = data else {
                print("No user data returned from login")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let authData = try decoder.decode(AuthResponse.self, from: data)
                if let token = authData.token {
                    AuthController.keychain.set(token, forKey: AuthController.authKeychainToken)
                } else {
                    print("error saving user token in keychain")
                }
            } catch {
                print("Error decoding login response data from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
            
        }.resume()
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

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error registering user: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                    return
                }
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    // User already has an account for this email address
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
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
                    AuthController.keychain.set(token, forKey: AuthController.authKeychainToken)
                } else {
                    print("Error saving token in keychain")
                }
            } catch {
                print("Error decoding registration response data from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
            
        }.resume()
    }
    
    static func isLoggedIn() -> Bool {
        return keychain.get(authKeychainToken) != nil
    }
    
}
