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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var dailyVibeView: UIView!
    @IBOutlet var searchResultsView: UIView!
    
    var currentUser: User?
    var network = Network.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    private func updateViews() {
        if Network.isLoggedIn() {
            // Hide Back Button
            self.navigationItem.hidesBackButton = true
            
            // Change Button to Logout
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
            
            // Update NameLabel
            network.getMyName { (result) in
                if let name = try? result.get() {
                    self.nameLabel.text = name
                }
            }
            
            // Update WeightLabel
            network.getMyWeight { (result) in
                if let weight = try? result.get() {
                    self.currentWeightLabel.text = String(weight)
                }
            }
            
            // Check to see if has profile
            network.checkForProfile { (bool) in
                if !bool {
                    self.performSegue(withIdentifier: "MissingProfile", sender: self)
                }
            }
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func logoutTapped() {
        let keychain = KeychainSwift()
        keychain.clear()
        self.navigationController?.popToRootViewController(animated: true)
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
