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

    @IBOutlet var genderPickerView: UIPickerView!
    @IBOutlet var ageTextView: CustomTextField!
    @IBOutlet var goalWeightTextView: CustomTextField!
    
    var nutritionController: LSLUserController?
    var createProfileDelegate: CreateProfileCompletionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self

        self.ageTextView.delegate = self
        self.goalWeightTextView.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.goalWeightTextView.resignFirstResponder()
    }
    
    @IBAction func toActivityLevel(_ sender: CustomButton) {
        self.performSegue(withIdentifier: "ToActivityLevel", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToActivityLevel" {
            guard let apVC = segue.destination as? LSLActivityLevelViewController else { return }
            guard let age = self.ageTextView.text, !age.isEmpty else { return self.nutritionController!.alertEmptyTextField(controller: self, field: "Age") }
            guard let goalWeight = self.goalWeightTextView.text, !goalWeight.isEmpty else { return self.nutritionController!.alertEmptyTextField(controller: self, field: "Goal Weight") }

            var gender: String = ""
            for index in 0..<self.genderPickerView!.numberOfComponents {
                gender = self.nutritionController!.genders[self.genderPickerView.selectedRow(inComponent: index)]
            }
            if gender == "Male" {
                LSLUserController.gender = true
            } else if gender == "Female" {
                LSLUserController.gender = false
            } else {
                LSLUserController.gender = nil
            }

            LSLUserController.age = Int(age)
            LSLUserController.goalWeight = Int(goalWeight)
            
            apVC.nutritionController = self.nutritionController
            apVC.createProfileDelegate = self.createProfileDelegate
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
        return self.nutritionController!.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
