//
//  userREST.swift
//  Nutrivurv
//
//  Created by Dillon on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct userREST: Codable {
    let name: String?
    let email: String
    let password: String
}
