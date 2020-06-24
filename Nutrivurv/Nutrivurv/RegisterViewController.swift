//
//  RegisterViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var nameTextField: CustomTextField!
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var registerButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isSelected = false
        self.navigationItem.hidesBackButton = true
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    // MARK: - IBActions and Methods
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let name = self.nameTextField.text, !name.isEmpty,
            let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty,
            let confirmedPassword = self.confirmPasswordTextField.text, !confirmedPassword.isEmpty else {
                completeFieldsAlert()
                return
        }
        
        guard email.isValidEmail() else {
            invalidEmailAlert()
            return
        }
        
        guard password == confirmedPassword else {
            passwordsDontMatchAlert()
            return
        }
        
        let newUser = User(name: name, email: email, password: password)
        
        activityIndicator.startAnimating()
        registerButton.isEnabled = false
        registerButton.layer.opacity = 0.45
        
        UserAuthController.shared.registerUser(user: newUser) { (result) in
            
            // TODO: update this switch statement once status response codes are implemented on backend
            
            switch result {
            case .success(true):
                self.performSegue(withIdentifier: "ToDashboard", sender: self)
            case .failure(.badAuth):
                self.accountAlreadyExistsAlert()
            default:
                self.generalRegistrationError()
            }
            
            self.registerButton.isEnabled = true
            self.registerButton.layer.opacity = 1.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - AlertControllers
    
    private func completeFieldsAlert() {
        createAndDisplayAlertController(title: "Complete All Fields", message: "Please ensure you have completed all required fields.")
    }
    
    private func generalRegistrationError() {
        createAndDisplayAlertController(title: "Registration failed", message: "We were unable to create an account for you. Please try again.")
    }
    
    private func passwordsDontMatchAlert() {
        createAndDisplayAlertController(title: "Passwords don't match", message: "Please re-enter and confirm your password.")
    }
    
    private func accountAlreadyExistsAlert() {
        createAndDisplayAlertController(title: "Couldn't Complete Registration", message: "A user account matching your credentials already exists. Please log in to your dashboard.")
    }
    
    private func invalidEmailAlert() {
        createAndDisplayAlertController(title: "Invalid Email", message: "Please double check that you have accurately input your email.")
    }
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Custom Keyboard Dismissal
    
    @objc func dismissKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }
}

// MARK: - UITextField Delegate Methods

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            registerButtonTapped(self)
        default:
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
