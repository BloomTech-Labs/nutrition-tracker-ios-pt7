//
//  LSLFoodDetailViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLFoodDetailViewController: UIViewController {
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var servingSizePickerView: UIPickerView!
    @IBOutlet weak var mealTypePickerView: UIPickerView!
    
    var servingSizes: [String] = ["Serving", "Whole", "Jumbo", "Gram", "Ounce", "Pound", "Kilogram", "Cup", "Liter"]
    var mealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qtyTextField.delegate = self

        self.servingSizePickerView.delegate = self
        self.servingSizePickerView.dataSource = self
        
        self.mealTypePickerView.delegate = self
        self.mealTypePickerView.dataSource = self
                
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.qtyTextField.resignFirstResponder()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LSLFoodDetailViewController: UIPickerViewDelegate {
}

extension LSLFoodDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes.count
        default:
            return self.mealTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes[row]
        default:
            return self.mealTypes[row]
        }
    }
}

extension LSLFoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
