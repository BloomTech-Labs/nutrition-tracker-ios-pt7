//
//  StringHelperFunctions.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func getCGFloatfromString() -> CGFloat? {
        let decimals = Set("0123456789.")
        let value = self.filter{ decimals.contains($0) }
        
        guard let double = Double(value) else { return 0.0 }
        
        return CGFloat(double)
    }
}
