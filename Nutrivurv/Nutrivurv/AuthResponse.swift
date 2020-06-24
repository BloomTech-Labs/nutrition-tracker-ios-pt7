//
//  AuthResponse.swift
//  Nutrivurv
//
//  Created by Dillon on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    let message: String?
    let token: String?
    let error: String?
}
