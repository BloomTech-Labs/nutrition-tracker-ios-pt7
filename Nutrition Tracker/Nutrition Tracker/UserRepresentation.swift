//
//  UserRepresentation.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct UserRepresentation: Equatable, Codable {
    let id: UUID?
    let name: String
    let email: String?
    let createdAt: String?
    let updatedAt: String?
}
