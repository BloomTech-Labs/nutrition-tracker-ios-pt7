//
//  ActivityLevel.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ActivityLevel: Codable {
    var level: Int
    var name: String
    var description: String
    var isSelected: Bool
    
    init(level: Int, name: String, description: String, isSelected: Bool = false) {
        self.level = level
        self.name = name
        self.description = description
        self.isSelected = isSelected
    }
}
