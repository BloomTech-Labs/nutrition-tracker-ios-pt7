//
//  LSLLoginViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLLoginViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var submitButton: CustomButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Back Button
        self.navigationItem.hidesBackButton = true

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    @IBAction func login(_ sender: Any) {
        guard let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else {
                completeFieldsAlert()
                return
        }
        
        Network.shared.loginUser(email: email, password: password) { (result) in
            
            switch result {
            case .success(true):
                self.performSegue(withIdentifier: "LoginToDashboard", sender: self)
            case .failure(.badAuth):
                self.incorrectCredentialsAlert()
            default:
                self.generalLoginError()
            }
        }
    }
    
    private func completeFieldsAlert() {
        let alertController = UIAlertController(title: "Complete All Fields", message: "Please enter your email and password in order to log in.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func incorrectCredentialsAlert() {
        let alertController = UIAlertController(title: "Login Error", message: "Incorrect email or password.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func generalLoginError() {
        let alertController = UIAlertController.init(title: "Login failed", message: "We were unable to log you in. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    @objc func dismissKeyboard() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    private func clearTextFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
}

extension LSLLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            self.login(self)
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
