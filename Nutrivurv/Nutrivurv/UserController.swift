//
//  UserController.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import KeychainSwift

class UserController {
    static let shared = UserController()
    
    static let authKeychainToken = "authorizationToken"
    static let userPassKey = "userPassKey"
    static let userEmailKey = "userEmailKey"
    static let keychain = KeychainSwift()
    
    private let baseURL = URL(string: "https://nutrivurv-be.herokuapp.com/api/auth")!
    
    var userProfileData: UserProfile? {
        didSet {
            if let caloricBudget = userProfileData?.caloricBudget {
                UserDefaults.standard.set(caloricBudget, forKey: UserDefaults.Keys.caloricBudget)
            }
            
            if let carbsBudget = userProfileData?.carbsBudget {
                UserDefaults.standard.set(carbsBudget, forKey: UserDefaults.Keys.carbsBudget)
            }
            
            if let proteinBudget = userProfileData?.proteinBudget {
                UserDefaults.standard.set(proteinBudget, forKey: UserDefaults.Keys.proteinBudget)
            }
            
            if let fatBudget = userProfileData?.fatBudget {
                UserDefaults.standard.set(fatBudget, forKey: UserDefaults.Keys.fatBudget)
            }
        }
    }
    
    func loginUser(user: UserAuth, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: loginURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            print("Error encoding user for login")
            DispatchQueue.main.async {
                completion(.failure(.noEncode))
            }
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
                if response.statusCode == 401 {
                    // Incorrect password
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
                    return
                    
                } else if response.statusCode == 500 {
                    // Internal server error
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
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
                let authData = try decoder.decode(UserAuthResponse.self, from: data)
                if let token = authData.token {
                    UserController.keychain.set(token, forKey: UserController.authKeychainToken)
                } else {
                    print("error saving user token in keychain")
                }
                
                self.userProfileData = authData.user
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
    
    func registerUser(user: UserProfile, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let registerURL = baseURL.appendingPathComponent("ios/register")
        var request = URLRequest(url: registerURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            print("Error encoding user data for registration")
            DispatchQueue.main.async {
                completion(.failure(.noEncode))
            }
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
                if response.statusCode == 409 {
                    // User already has an account for this email address
                    DispatchQueue.main.async {
                        completion(.failure(.badAuth))
                    }
                    return
                    
                } else if response.statusCode == 500 {
                    // Internal server error
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
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
            var response: UserAuthResponse?
            
            do {
                response = try decoder.decode(UserAuthResponse.self, from: data)
            } catch {
                print("Error decoding registration response data from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
            
            guard let authResponse = response else {
                print("Auth response returned nil")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            if let token = authResponse.token {
                UserController.keychain.set(token, forKey: UserController.authKeychainToken)
            } else {
                print("Error saving auth token in keychain")
                DispatchQueue.main.async {
                    completion(.failure(.noToken))
                }
                return
            }
            
            if let password = user.password, let id = authResponse.user.id {
                UserDefaults.standard.set(id, forKey: UserDefaults.Keys.userIdKey)
                UserController.keychain.set(user.email, forKey: UserController.userEmailKey)
                UserController.keychain.set(password, forKey: UserController.userPassKey)

                self.userProfileData = UserProfile(id: authResponse.user.id, name: authResponse.user.name, email: authResponse.user.email, password: password, fatPctRatio: authResponse.user.fatPctRatio, carbsPctRatio: authResponse.user.carbsPctRatio, proteinPctRatio: authResponse.user.proteinPctRatio)
            } else {
                print("Error initializing new user profile")
                DispatchQueue.main.async {
                    completion(.failure(.objectInitFailed))
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
