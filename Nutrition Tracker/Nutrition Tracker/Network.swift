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

class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let keychain = KeychainSwift()
        let token = keychain.get(LSLLoginViewController.loginKeychainKey) ?? ""
        let url = URL(string: "https://labspt7-nutrition-tracker-be.herokuapp.com/")!

        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = ["authorization": "Bearer \(token)"]

        return ApolloClient(
            networkTransport: HTTPNetworkTransport(url: url, session: URLSession(configuration: configuration))
        )
    }()
}
