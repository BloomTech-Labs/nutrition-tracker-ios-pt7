//
//  LSLMacroTableViewCellDelegate.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol LSLMacroTableViewCellDelegate: class {
    func tappedCheckbox(on cell: LSLMacroTableViewCell)
}
