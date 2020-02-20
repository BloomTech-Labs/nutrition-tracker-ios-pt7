//
//  AuthPayload.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct AuthPayload: Codable {
    let token: String
    let user: UserRepresentation
}
