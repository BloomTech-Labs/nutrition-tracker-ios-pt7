//
//  NutritionLabel.swift
//  Nutrivurv
//
//  Created by Dillon on 6/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class NutritionLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        super.drawText(in: rect.inset(by: insets))
    }
}
