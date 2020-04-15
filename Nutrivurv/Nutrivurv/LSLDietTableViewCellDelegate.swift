//
//  LSLDietTableViewCellDelegate.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol LSLDietTableViewCellDelegate: class {
    func tappedRadioButton(on cell: LSLDietTableViewCell)
    func tappedInfoButton(on cell: LSLDietTableViewCell)
}
