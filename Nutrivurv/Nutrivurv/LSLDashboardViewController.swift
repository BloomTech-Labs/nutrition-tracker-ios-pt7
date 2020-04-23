//
//  LSLDashboardViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import KeychainSwift

class LSLDashboardViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
        
    var isLoggedIn: Bool = false
    var dashboardController = LSLDashboardController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Back Button
        self.navigationItem.hidesBackButton = true
        // Change Button to Logout
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))

        if Network.isLoggedIn() {
            self.isLoggedIn = true
        } else {
            self.performSegue(withIdentifier: "Logout", sender: self)
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isLoggedIn {
            self.updateViews()
        }
    }
    
    private func updateViews() {
        // Check to see if has profile
        dashboardController.checkForProfile { (bool) in
            if !bool {
                print("Missing profile")
                self.performSegue(withIdentifier: "MissingProfile", sender: self)
            } else {
                // Update NameLabel
                self.dashboardController.getMyName { (result) in
                    if let name = try? result.get() {
                        self.title = name
                    } else {
                        print("Couldn't get name: \(result)")
                    }
                }

                // Update WeightLabel
                self.dashboardController.getMyWeight { (result) in
                    if let weight = try? result.get() {
                        self.currentWeightLabel.text = String(weight)
                    } else {
                        print("Couldn't get weight: \(result)")
                    }
                }
            }
        }
    }
    
    @objc func logoutTapped() {
        let keychain = KeychainSwift()
        keychain.clear()
        print("Logging Out")
        self.performSegue(withIdentifier: "Logout", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
