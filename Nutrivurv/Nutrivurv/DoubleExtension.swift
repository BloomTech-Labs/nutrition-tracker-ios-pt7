//
//  DoubleExtension.swift
//  Nutrivurv
//
//  Created by Dillon on 8/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
