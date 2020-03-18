//
//  LSLLoginViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Apollo
import KeychainSwift

class LSLLoginViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var submitButton: CustomButton!
    
    static let loginKeychainKey = "login"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    // MARK: - IBActions and Methods
    @IBAction func login(_ sender: UIButton) {
        guard let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else { return }
        
        Network.shared.apollo.perform(mutation: LoginMutation(data: LoginUserInput(email: email, password: password))) { [weak self] result in
            switch result {
                case .success(let graphQLResult):
                    if let token = graphQLResult.data?.login.token {
                        let keychain = KeychainSwift()
                        keychain.set(token, forKey: LSLLoginViewController.loginKeychainKey)
                        self?.performSegue(withIdentifier: "LoginToDashboard", sender: self)
                    }
                    if let errors = graphQLResult.errors {
                        print("Errors from server: \(errors)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
    }
    
    @objc func dismissKeyboard() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    static public func isLoggedIn() -> Bool {
      let keychain = KeychainSwift()
      return keychain.get(LSLLoginViewController.loginKeychainKey) != nil
    }
}

extension LSLLoginViewController: UITextFieldDelegate {
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
