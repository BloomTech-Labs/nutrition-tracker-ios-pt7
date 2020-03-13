//
//  LSLMetricBMIViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLMetricBMIViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet public var heightMetricTextField: UITextField!
    @IBOutlet public var weightMetricTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.heightMetricTextField.delegate = self
        self.weightMetricTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.heightMetricTextField.resignFirstResponder()
        self.weightMetricTextField.resignFirstResponder()
    }
    
    private func calculateBMI() -> String {
        guard let height = self.heightMetricTextField.text, !height.isEmpty,
            let weight = self.weightMetricTextField.text, !weight.isEmpty else {
            NSLog("The user forgot to enter information needed to calculate BMI")
            return ""
        }
        
        let newHeight = ((Double(height) ?? 0) / 2.54)
        LSLNutritionController.height = Int(newHeight)
        let totalWeight = ((Double(weight) ?? 0) * 2.20462262185)
        LSLNutritionController.weight = Int(totalWeight)

        let bmi = (totalWeight * 704.7) / (newHeight * newHeight)
        let roundedBMI = String(format: "%.2f", bmi)

        return roundedBMI
    }
}

extension LSLMetricBMIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == heightMetricTextField {
            textField.resignFirstResponder()
            weightMetricTextField.becomeFirstResponder()
        } else if textField == weightMetricTextField {
            textField.resignFirstResponder()
        }
        if !self.heightMetricTextField.text!.isEmpty && !self.weightMetricTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor(red: 0.996, green: 0.259, blue: 0.702, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor(red: 0.651, green: 0.455, blue: 1, alpha: 0.5).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        if !self.heightMetricTextField.text!.isEmpty && !self.weightMetricTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
        if !self.heightMetricTextField.text!.isEmpty && !self.weightMetricTextField.text!.isEmpty {
            LSLNutritionController.bmi = self.calculateBMI()
        }
    }
}
