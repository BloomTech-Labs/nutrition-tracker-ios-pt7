//
//  CustomButton.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        layer.cornerRadius = 6
    }
}
