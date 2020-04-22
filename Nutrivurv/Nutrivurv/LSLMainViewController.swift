//
//  LSLMainViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLMainViewController: UIViewController {

    @IBOutlet var signInButton: CustomButton!
    @IBOutlet var signUpButton: CustomButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        
        if Network.isLoggedIn() {
            self.performSegue(withIdentifier: "ShowDashboard", sender: nil)
        }
    }
}
