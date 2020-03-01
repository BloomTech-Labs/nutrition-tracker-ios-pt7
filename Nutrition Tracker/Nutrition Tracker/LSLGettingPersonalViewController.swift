//
//  LSLGettingPersonalViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLGettingPersonalViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties

    @IBOutlet var agePickerView: UIPickerView!
    @IBOutlet var genderPickerView: UIPickerView!
    @IBOutlet var goalWeightTextView: CustomTextField!
    
    var ages = ["Under 18", "18-25", "25-30", "30-35", "35-45", "45+"]
    var genders = ["Male", "Female", "Prefer not to say"]
    var name: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.agePickerView.delegate = self
        self.agePickerView.dataSource = self
        
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self

        self.goalWeightTextView.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    
    func alertEmptyTextField(field: String) {
        let alert = UIAlertController(title: "\(field) is Empty", message: "\(field) is Required. Please fill it out before proceeding.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.goalWeightTextView.resignFirstResponder()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDietaryPreference" {
            guard let dpVC = segue.destination as? LSLDietaryPreferenceViewController else { return }
            guard let goalWeight = self.goalWeightTextView.text, !goalWeight.isEmpty else { return alertEmptyTextField(field: "Goal Weight") }
            
            var age: String = ""
            for index in 0..<self.agePickerView!.numberOfComponents {
                age = self.ages[self.agePickerView.selectedRow(inComponent: index)]
            }
            
            var gender: String = ""
            for index in 0..<self.genderPickerView!.numberOfComponents {
                gender = self.genders[self.genderPickerView.selectedRow(inComponent: index)]
            }
            
            dpVC.name = self.name
            dpVC.email = self.email
            dpVC.password = self.password
            dpVC.age = age
            dpVC.gender = gender
            dpVC.goalWeight = goalWeight
        }
    }
}

extension LSLGettingPersonalViewController: UIPickerViewDelegate {
}

extension LSLGettingPersonalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.agePickerView {
            return self.ages.count
        }
        
        return self.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.agePickerView {
            return self.ages[row]
        }
        
        return self.genders[row]
    }
}

extension LSLGettingPersonalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
    }
}
