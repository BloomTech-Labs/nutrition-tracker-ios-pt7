//
//  LSLMacroPreference.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct LSLMacroPreference: Codable {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
