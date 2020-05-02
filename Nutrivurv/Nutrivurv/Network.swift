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
    static let loginKeychainKey = "login"
    var apollo: ApolloClient = createApolloClient()
    
    private init() { }
    
    static func createApolloClient() -> ApolloClient {
        let keychain = KeychainSwift()
        let token = keychain.get(Network.loginKeychainKey) ?? ""
        let url = URL(string: "https://labspt7-nutrition-tracker-be.herokuapp.com/")!
        let configuration = URLSessionConfiguration.default
        
        if token != "" {
            configuration.httpAdditionalHeaders = ["authorization": "Bearer \(token)"]
        }

        return ApolloClient(
            networkTransport: HTTPNetworkTransport(url: url, session: URLSession(configuration: configuration))
        )
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        apollo.perform(mutation: LoginMutation(data: LoginUserInput(email: email, password: password))) { result in
            switch result {
                case .success(let graphQLResult):
                    guard let token = graphQLResult.data?.login.token else {
                        print("Bad Data: \(graphQLResult)")
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
                    self.apollo = Network.createApolloClient()

                    completion(.success(true))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(.noAuth))
            }
        }
    }
    
    func createUser(name: String, email: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        self.apollo.perform(mutation: CreateUserMutation(data: CreateUserInput(name: name, email: email, password: password))) { result in
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
                    self.apollo = Network.createApolloClient()

                    completion(.success(true))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(.noAuth))
            }
        }
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
    
    static func isLoggedIn() -> Bool {
      let keychain = KeychainSwift()
        return keychain.get(Network.loginKeychainKey) != nil
    }
}
