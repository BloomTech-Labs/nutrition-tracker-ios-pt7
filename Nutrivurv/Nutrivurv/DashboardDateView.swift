//
//  DashboardDateView.swift
//  Nutrivurv
//
//  Created by Dillon on 7/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class DashboardDateView: UIView {
    
    override var intrinsicContentSize: CGSize {
        let orginalContentSize = super.intrinsicContentSize
        layer.cornerRadius = orginalContentSize.height / 2
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        
        return CGSize(width: orginalContentSize.width, height: orginalContentSize.height)
    }
    
}
