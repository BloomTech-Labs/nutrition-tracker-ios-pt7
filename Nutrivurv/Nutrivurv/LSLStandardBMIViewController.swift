//
//  LSLStandardBMIViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLStandardBMIViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet public var heightStandardFeetTextField: UITextField!
    @IBOutlet public var heightStandardInchesTextField: UITextField!
    @IBOutlet public var weightStandardTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightStandardFeetTextField.delegate = self
        self.heightStandardInchesTextField.delegate = self
        self.weightStandardTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(calculateBMI), name: .calculateBMIStandard, object: nil)
        
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.heightStandardFeetTextField.resignFirstResponder()
        self.heightStandardInchesTextField.resignFirstResponder()
        self.weightStandardTextField.resignFirstResponder()
    }
    
    @discardableResult @objc public func calculateBMI() -> String? {
        guard let feet = self.heightStandardFeetTextField.text, !feet.isEmpty,
            let inches = self.heightStandardInchesTextField.text, !inches.isEmpty,
            let weight = self.weightStandardTextField.text, !weight.isEmpty else {
                return nil
        }
        
        guard let feetDouble = Double(feet), feetDouble != 0, let inchesDouble = Double(inches), let weightDouble = Double(weight), weightDouble != 0 else {
            NotificationCenter.default.post(name: .bmiInputsNotNumbers, object: nil)
            return nil
        }
        
        let height = ((feetDouble) * 12) + (inchesDouble)
        LSLUserController.height = Int(height)
        let totalWeight = weightDouble
        LSLUserController.weight = Int(totalWeight)
        
        let bmi = (totalWeight * 704.7) / (height * height)
        let roundedBMI = String(format: "%.2f", bmi)
        
        if LSLUserController.bmi == roundedBMI {
            return nil
        } else {
            LSLUserController.bmi = roundedBMI
        }
        
        return roundedBMI
    }
}

// MARK: - UITextField Delegate Methods

extension LSLStandardBMIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == heightStandardFeetTextField {
            heightStandardInchesTextField.becomeFirstResponder()
        } else if textField == heightStandardInchesTextField {
            weightStandardTextField.becomeFirstResponder()
        } else if textField == weightStandardTextField {
            textField.resignFirstResponder()
        }
        if !self.heightStandardFeetTextField.text!.isEmpty && !self.heightStandardInchesTextField.text!.isEmpty && !self.weightStandardTextField.text!.isEmpty {
            self.calculateBMI()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor(red: 0, green: 0.455, blue: 0.722, alpha: 0.5).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
    }
}
