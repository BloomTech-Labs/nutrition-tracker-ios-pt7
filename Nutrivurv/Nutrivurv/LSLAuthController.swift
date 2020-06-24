//
//  LSLAuthController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class AuthController {
    static let shared  = AuthController()
    
    private let baseURL = URL(string: "https://nutrivurv-be.herokuapp.com/auth")!
    
    func loginUser(email: String, pasword: String, completion: @escaping (Error?) -> Void) {
        
    }
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        
    }
}
