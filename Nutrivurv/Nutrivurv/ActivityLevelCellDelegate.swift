//
//  ActivityLevelCellDelegate.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol ActivityLevelCellDelegate: class {
    func tappedRadioButton(on cell: ActivityLevelTableViewCell)
}
