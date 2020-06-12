//
//  LSLRegisterViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

class LSLRegisterViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var nameTextField: CustomTextField!
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var confirmPasswordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Back Button
        self.navigationItem.hidesBackButton = true
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    // MARK: - IBActions and Methods
    
    @IBAction func register(_ sender: CustomButton) {
        guard let name = self.nameTextField.text, !name.isEmpty,
            let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty,
            let confirmedPassword = self.confirmPasswordTextField.text, !confirmedPassword.isEmpty else { return }
        
        guard password == confirmedPassword else {
            passwordsDontMatchAlert()
            return
        }
        
        Network.shared.createUser(name: name, email: email, password: password) { (result) in
            if result == .failure(.badAuth) {
                self.accountAlreadyExistsAlert()
                return
            } else if result == .failure(.noAuth) || result == .failure(.otherError) {
                self.generalRegistrationError()
                return
            } else {
                self.performSegue(withIdentifier: "ToCalculateBMI", sender: self)
            }
        }
    }
    
    private func generalRegistrationError() {
        let alertController = UIAlertController.init(title: "Registration failed", message: "We were unable to create an account for you. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func passwordsDontMatchAlert() {
        let alertController = UIAlertController.init(title: "Passwords don't match", message: "Please re-enter and confirm your password.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func accountAlreadyExistsAlert() {
        let alertController = UIAlertController.init(title: "Couldn't Complete Registration", message: "A user account matching your credentials already exists. Please log in to your dashboard.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }
    
    private func clearTextFields() {
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }
}

extension LSLRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
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
