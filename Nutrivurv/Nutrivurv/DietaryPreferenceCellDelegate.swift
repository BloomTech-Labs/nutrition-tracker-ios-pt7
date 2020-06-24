//
//  DietaryPreferenceCellDelegate.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol DietaryPreferenceCellDelegate: class {
    func tappedRadioButton(on cell: DietaryPreferenceTableViewCell)
    func tappedInfoButton(on cell: DietaryPreferenceTableViewCell)
}
