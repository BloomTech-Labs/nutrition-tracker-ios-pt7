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
        signUpButton.layer.borderColor = UIColor(red: 0.996, green: 0.259, blue: 0.702, alpha: 1).cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Network.isLoggedIn() {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowDashboard", sender: nil)
            }
        }
    }
}
