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
    
    var nutritionController: LSLNutritionController?
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
        
        // Testing... Delete these when finished
        self.goalWeightTextView.text = "190"
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.goalWeightTextView.resignFirstResponder()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDietaryPreference" {
            guard let dpVC = segue.destination as? LSLDietaryPreferenceViewController,
                let nc = self.nutritionController else { return }
            guard let goalWeight = self.goalWeightTextView.text, !goalWeight.isEmpty else { return nc.alertEmptyTextField(controller: self, field: "Goal Weight") }
            
//            var age: String = ""
//            for index in 0..<self.agePickerView!.numberOfComponents {
//                age = nc.ages[self.agePickerView.selectedRow(inComponent: index)]
//            }
//
//            var gender: String = ""
//            for index in 0..<self.genderPickerView!.numberOfComponents {
//                gender = nc.genders[self.genderPickerView.selectedRow(inComponent: index)]
//            }
            
            // Testing... Delete these when finished
            let age: String = nc.ages[4]
            let gender: String = nc.genders[0]
            
            dpVC.nutritionController = nc
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
            return self.nutritionController!.ages.count
        }
        
        return self.nutritionController!.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.agePickerView {
            return self.nutritionController!.ages[row]
        }
        
        return self.nutritionController!.genders[row]
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
