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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else {
                completeFieldsAlert()
                return
        }
        activityIndicator.startAnimating()
        submitButton.isEnabled = false
        submitButton.layer.opacity = 0.45
        
        Network.shared.loginUser(email: email, password: password) { (result) in
            
            switch result {
            case .success(true):
                self.performSegue(withIdentifier: "LoginToDashboard", sender: self)
            case .failure(.badAuth):
                self.incorrectCredentialsAlert()
            default:
                self.generalLoginError()
            }
            
            self.submitButton.isEnabled = true
            self.submitButton.layer.opacity = 1.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Alert Controllers
    
    private func completeFieldsAlert() {
        createAndDisplayAlertController(title: "Complete All Fields", message: "Please enter your email and password in order to log in.")
    }
    
    private func incorrectCredentialsAlert() {
        createAndDisplayAlertController(title: "Login Error", message: "Incorrect email or password. Please try again.")
    }
    
    private func generalLoginError() {
        createAndDisplayAlertController(title: "Login failed", message: "We were unable to log you in. Please try again.")
    }
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Custom Keyboard Dismissal
    
    @objc func dismissKeyboard() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

// MARK: - UITextField Delegate Methods

extension LSLLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            self.loginButtonTapped(self)
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
