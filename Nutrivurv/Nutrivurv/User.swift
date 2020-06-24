//
//  User.swift
//  Nutrivurv
//
//  Created by Dillon on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String?
    let email: String
    let password: String
    
    init(name: String? = nil, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}

struct UserAuthResponse: Codable {
    let message: String?
    let token: String?
    let error: String?
}

