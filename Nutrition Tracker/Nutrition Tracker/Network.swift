//
//  Network.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Apollo
import KeychainSwift

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noEncode
    case noDecode
}

class Network {
    static let shared = Network()
    
    private init() { }
    
    static let loginKeychainKey = "login"

    private var apollo: ApolloClient = {
        let keychain = KeychainSwift()
        let token = keychain.get(Network.loginKeychainKey) ?? ""
        let url = URL(string: "https://labspt7-nutrition-tracker-be.herokuapp.com/")!

        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = ["authorization": "Bearer \(token)"]

        return ApolloClient(
            networkTransport: HTTPNetworkTransport(url: url, session: URLSession(configuration: configuration))
        )
    }()
    
    func createUser(name: String, email: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        apollo.perform(mutation: CreateUserMutation(data: CreateUserInput(name: name, email: email, password: password))) { result in
            switch result {
                case .success(let graphQLResult):
                    guard let token = graphQLResult.data?.createUser.token else {
                        completion(.failure(.badAuth))
                        return
                    }
                    
                    guard graphQLResult.errors == nil else {
                        print("Errors from server: \(graphQLResult.errors!)")
                        completion(.failure(.otherError))
                        return
                    }

                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: Network.loginKeychainKey)
                    completion(.success(true))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(.noAuth))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        apollo.perform(mutation: LoginMutation(data: LoginUserInput(email: email, password: password))) { result in
            switch result {
                case .success(let graphQLResult):
                    guard let token = graphQLResult.data?.login.token else {
                        completion(.failure(.badAuth))
                        return
                    }
                    
                    guard graphQLResult.errors == nil else {
                        print("Errors from server: \(graphQLResult.errors!)")
                        completion(.failure(.otherError))
                        return
                    }
                    
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: Network.loginKeychainKey)
                    completion(.success(true))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(.noAuth))
            }
        }
    }
    
    static func isLoggedIn() -> Bool {
      let keychain = KeychainSwift()
        return keychain.get(Network.loginKeychainKey) != nil
    }
    
    func createProfile(age: Int, weight: Int, height: Int, gender: Bool?, goalWeight: Int?, activityLevel: Int?, diet: String?, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        apollo.perform(mutation: CreateProfileMutation(data: CreateProfileInput(age: age, weight: weight, height: height, gender: gender, goalWeight: goalWeight, activityLevel: activityLevel, diet: diet))) { result in
            switch result {
                case .success(let graphQLResult):
                    guard graphQLResult.data?.createProfile.id != nil else {
                        completion(.failure(.badData))
                        return
                    }
                    
                    guard graphQLResult.errors == nil else {
                        print("Errors from server: \(graphQLResult.errors!)")
                        completion(.failure(.otherError))
                        return
                    }
                
                    completion(.success(true))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(.noAuth))
            }
        }
    }
    
    func getMyName(completion: @escaping (Result<String, NetworkError>) -> Void) {
        apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                guard let name = graphQLResult.data?.me.name else {
                    completion(.failure(.badData))
                    return
                }
                
                guard graphQLResult.errors == nil else {
                    print("Errors from server: \(graphQLResult.errors!)")
                    completion(.failure(.otherError))
                    return
                }
                
                completion(.success(name))
            case .failure(let error):
              // Network or response format errors
              print(error)
            }
        }
    }
    
    func checkForProfile(completion: @escaping (Bool) -> Void) {
        apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                guard graphQLResult.data?.me.profile != nil else {
                    print("Profile isn't returning: \(String(describing: graphQLResult.data?.me))")
                    completion(false)
                    return
                }
                
                guard graphQLResult.errors == nil else {
                    print("Errors from server: \(graphQLResult.errors!)")
                    completion(false)
                    return
                }
                
                completion(true)
            case .failure(let error):
              // Network or response format errors
              print(error)
            }
        }
    }
    
    func getMyWeight(completion: @escaping (Result<Int, NetworkError>) -> Void) {
        apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                guard let weight = graphQLResult.data?.me.profile?.weight else {
                    completion(.failure(.badData))
                    return
                }
                
                guard graphQLResult.errors == nil else {
                    print("Errors from server: \(graphQLResult.errors!)")
                    completion(.failure(.otherError))
                    return
                }
                
                completion(.success(weight))
            case .failure(let error):
              // Network or response format errors
              print(error)
            }
        }
    }
}
