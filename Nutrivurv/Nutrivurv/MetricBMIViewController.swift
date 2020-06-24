//
//  MetricBMIViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class MetricBMIViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet public var heightMetricTextField: UITextField!
    @IBOutlet public var weightMetricTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightMetricTextField.delegate = self
        self.weightMetricTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(calculateBMI), name: .calculateBMIMetric, object: nil)
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.heightMetricTextField.resignFirstResponder()
        self.weightMetricTextField.resignFirstResponder()
    }
    
    @discardableResult @objc public func calculateBMI() -> String? {
        guard let height = self.heightMetricTextField.text, !height.isEmpty,
            let weight = self.weightMetricTextField.text, !weight.isEmpty else {
                return nil
        }
        
        guard let heightDouble = Double(height), heightDouble != 0, let weightDouble = Double(weight), weightDouble != 0 else {
            NotificationCenter.default.post(name: .bmiInputsNotNumbers, object: nil)
            return nil
        }
        
        let newHeight = ((heightDouble) / 2.54)
        UserController.height = Int(newHeight)
        let totalWeight = ((weightDouble) * 2.20462262185)
        UserController.weight = Int(totalWeight)
        
        let bmi = (totalWeight * 704.7) / (newHeight * newHeight)
        let roundedBMI = String(format: "%.2f", bmi)
        
        if UserController.bmi == roundedBMI {
            return nil
        } else {
            UserController.bmi = roundedBMI
        }
        
        return roundedBMI
    }
}

// MARK: - UITextField Delegate Methods

extension MetricBMIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == heightMetricTextField {
            weightMetricTextField.becomeFirstResponder()
        } else if textField == weightMetricTextField {
            textField.resignFirstResponder()
        }
        if !self.heightMetricTextField.text!.isEmpty && !self.weightMetricTextField.text!.isEmpty {
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
