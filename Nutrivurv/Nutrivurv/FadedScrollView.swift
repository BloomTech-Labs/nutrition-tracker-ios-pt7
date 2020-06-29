//
//  FadedScrollView.swift
//  Nutrivurv
//
//  Created by Dillon on 6/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class FadedScrollView: UIScrollView {
    let startFadePercentage: Double = 0.03
    let endFadePercentage: Double = 0.10

    override func layoutSubviews() {

        super.layoutSubviews()

        let transparent = UIColor.clear.cgColor
        let opaque = UIColor(named: "bg-color")!.cgColor

        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [transparent, opaque, opaque, transparent]
        gradient.locations = [0, NSNumber(floatLiteral: startFadePercentage), NSNumber(floatLiteral: 1 - endFadePercentage), 1]

        self.layer.mask = gradient
    }
}
