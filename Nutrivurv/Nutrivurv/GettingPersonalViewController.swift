//
//  GettingPersonalViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class GettingPersonalViewController: UIViewController, UIPickerViewDelegate {
    
    
    // MARK: - IBOutlets and Properties

    @IBOutlet var biologicalSexPickerView: UIPickerView!
    @IBOutlet var birthDateTextField: CustomTextField!
    @IBOutlet var goalWeightTextField: CustomTextField!
    
    var profileController: ProfileCreationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.biologicalSexPickerView.delegate = self
        self.biologicalSexPickerView.dataSource = self

        self.birthDateTextField.delegate = self
        self.goalWeightTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If user has already completed information and is returning to a previous screen, this will set the info in view
        if let ageInt = ProfileCreationController.birthDate {
            birthDateTextField.text = String(ageInt)
        }
        
        if let goalWeightInt = ProfileCreationController.goalWeight {
            goalWeightTextField.text = String(goalWeightInt)
        }
        
        if let biologicalSex = ProfileCreationController.biologicalSex {
            switch biologicalSex {
            case BiologicalSex.female.rawValue:
                biologicalSexPickerView.selectRow(1, inComponent: 0, animated: true)
            default:
                // Defaults to male if unselected
                biologicalSexPickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    
    // MARK: - IBActions and Methods
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
    
    @IBAction func toActivityLevel(_ sender: Any) {
        guard let birthDate = birthDateTextField.text, !birthDate.isEmpty, checkForGoalWeight() != nil else {
            return
        }
        self.performSegue(withIdentifier: "ToActivityLevel", sender: self)
    }
    
    
    // MARK: - Helper Functions
    
    @discardableResult private func checkForGoalWeight() -> Int? {
        guard let goalWeight = self.goalWeightTextField.text, !goalWeight.isEmpty, let goalWeightInt = Int(goalWeight), goalWeightInt > 0 else {
            createAndDisplayAlertController(title: "Enter goal weight", message: "Please complete the goal weight input field by entering a valid number.")
            return nil
        }
        return goalWeightInt
    }
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToActivityLevel" {
            guard let nutritionController = profileController,
                let apVC = segue.destination as? ActivityLevelViewController else { return }
            
            guard let birthDate = birthDateTextField.text else {
                return
            }
            
            guard let goalWeightInt = checkForGoalWeight() else {
                return
            }

            let biologicalSexSelection = self.biologicalSexPickerView.selectedRow(inComponent: 0)
    
            switch biologicalSexSelection {
            case 0:
                ProfileCreationController.biologicalSex = BiologicalSex.male.rawValue
            default:
                ProfileCreationController.biologicalSex = BiologicalSex.female.rawValue
            }
            
            ProfileCreationController.birthDate = birthDate
            ProfileCreationController.goalWeight = goalWeightInt
            
            apVC.profileController = nutritionController
        }
    }
}


// MARK: - UIPickerView Data Source Methods

extension GettingPersonalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BiologicalSex.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BiologicalSex.allCases[row].rawValue
    }
}


// MARK: - UITextField Delegate Methods

extension GettingPersonalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case birthDateTextField:
            goalWeightTextField.becomeFirstResponder()
        case goalWeightTextField:
            textField.resignFirstResponder()
            self.toActivityLevel(self)
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
//        textField.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        textField.layer.borderColor = UIColor(named: "nutrivurv-blue-new")?.cgColor
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
