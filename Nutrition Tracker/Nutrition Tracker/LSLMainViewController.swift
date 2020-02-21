//
//  LSLMainViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import KeychainSwift

class LSLMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !self.isLoggedIn() {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    private func isLoggedIn() -> Bool {
      let keychain = KeychainSwift()
      return keychain.get(LSLLoginViewController.loginKeychainKey) != nil
    }
}
