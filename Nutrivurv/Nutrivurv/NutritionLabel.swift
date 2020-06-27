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
    override var text: String? {
        get {
            return super.text
        }
        set {
            if newValue == nil {
                super.text = nil
                return
            }
            var t = newValue!
            while t.count < 20 { t += " " }
            t += "\u{200c}"
            super.text = t
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        super.drawText(in: rect.inset(by: insets))
    }
}
