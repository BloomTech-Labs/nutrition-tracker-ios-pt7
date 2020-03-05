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
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    // MARK: - IBActions and Methods
    @IBAction func registerUser(_ sender: UIButton) {
        guard let name = self.nameTextField.text, !name.isEmpty,
            let email = self.emailTextField.text, !email.isEmpty,
//            let phone = self.emailTextField.text,
            let password = self.passwordTextField.text, !password.isEmpty else { return }
        
        apollo.perform(mutation: CreateUserMutation(data: CreateUserInput(name: name, email: email, password: password))) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.createUser.token {
                let keychain = KeychainSwift()
                keychain.set(token, forKey: LSLLoginViewController.loginKeychainKey)
                self?.dismiss(animated: true)
              }

              if let errors = graphQLResult.errors {
                print("Errors from server: \(errors)")
              }
            case .failure(let error):
              print("Error: \(error)")
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

extension LSLRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor(red: 0.251, green: 0.663, blue: 1, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor(red: 0.094, green: 0.565, blue: 1, alpha: 0.5).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
    }
}
