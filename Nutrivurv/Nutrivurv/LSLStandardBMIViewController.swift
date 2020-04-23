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
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.heightStandardFeetTextField.resignFirstResponder()
        self.heightStandardInchesTextField.resignFirstResponder()
        self.weightStandardTextField.resignFirstResponder()
    }
    
    private func calculateBMI() -> String {
        guard let feet = self.heightStandardFeetTextField.text, !feet.isEmpty,
            let inches = self.heightStandardInchesTextField.text, !inches.isEmpty,
            let weight = self.weightStandardTextField.text, !weight.isEmpty else {
            NSLog("The user forgot to enter information needed to calculate BMI")
            return ""
        }
        
        let height = ((Double(feet) ?? 0) * 12) + (Double(inches) ?? 0)
        LSLNutritionController.height = Int(height)
        let totalWeight = Double(weight) ?? 0
        LSLNutritionController.weight = Int(totalWeight)
        let bmi = (totalWeight * 704.7) / (height * height)
        let roundedBMI = String(format: "%.2f", bmi)

        return roundedBMI
    }
}

extension LSLStandardBMIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == heightStandardFeetTextField {
            textField.resignFirstResponder()
            heightStandardInchesTextField.becomeFirstResponder()
        } else if textField == heightStandardInchesTextField {
            textField.resignFirstResponder()
            weightStandardTextField.becomeFirstResponder()
        } else if textField == weightStandardTextField {
            textField.resignFirstResponder()
        }
        if !self.heightStandardFeetTextField.text!.isEmpty && !self.heightStandardInchesTextField.text!.isEmpty && !self.weightStandardTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
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
        if !self.heightStandardFeetTextField.text!.isEmpty && !self.heightStandardInchesTextField.text!.isEmpty && !self.weightStandardTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
        if !self.heightStandardFeetTextField.text!.isEmpty && !self.heightStandardInchesTextField.text!.isEmpty && !self.weightStandardTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
        }
    }
}
