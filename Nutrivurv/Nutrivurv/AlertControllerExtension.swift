//
//  AlertControllerExtension.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    class func createAlertWithDefaultAction(title: String, message: String, style: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
}
