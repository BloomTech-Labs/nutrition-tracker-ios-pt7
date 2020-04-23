//
//  LSLDashboardController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class LSLDashboardController {
    
    func checkForProfile(completion: @escaping (Bool) -> Void) {
        Network.shared.apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                guard let _ = graphQLResult.data?.me.profile?.id else {
                    print("Profile isn't returning: \(String(describing: graphQLResult.data?.me.profile?.id))")
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
    
    func getMyName(completion: @escaping (Result<String, NetworkError>) -> Void) {
        Network.shared.apollo.fetch(query: MeQuery()) { result in
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
    
    func getMyWeight(completion: @escaping (Result<Int, NetworkError>) -> Void) {
        Network.shared.apollo.fetch(query: MeQuery()) { result in
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
