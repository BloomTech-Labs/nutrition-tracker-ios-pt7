//
//  LSLRegisterViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit
import Apollo
import KeychainSwift

class LSLRegisterViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    // MARK: - IBActions and Methods
    
    func alertEmptyTextField(field: String) {
        let alert = UIAlertController(title: "\(field) is Empty", message: "\(field) is Required. Please fill it out before proceeding.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToGettingPersonal" {
            guard let gpVC = segue.destination as? LSLGettingPersonalViewController else { return }
            guard let name = self.nameTextField.text, !name.isEmpty else { return self.alertEmptyTextField(field: "Name") }
            guard let email = self.emailTextField.text, !email.isEmpty else { return self.alertEmptyTextField(field: "Email") }
            guard let password = self.passwordTextField.text, !password.isEmpty else { return self.alertEmptyTextField(field: "Password") }
            
            gpVC.name = name
            gpVC.email = email
            gpVC.password = password
        }
    }
}

extension LSLRegisterViewController: UITextFieldDelegate {
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
