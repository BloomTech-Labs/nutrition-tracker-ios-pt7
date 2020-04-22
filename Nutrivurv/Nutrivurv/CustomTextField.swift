//
//  CustomTextField.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextFields()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextFields()
    }

    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setupTextFields() {
        let borderWidth: CGFloat = 1.0
        let borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        let cornerRadius: CGFloat = 4
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        layer.cornerRadius = cornerRadius
    }
}
