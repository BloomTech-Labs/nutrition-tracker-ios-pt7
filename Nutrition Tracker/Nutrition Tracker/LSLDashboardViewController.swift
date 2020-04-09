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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        
        if Network.isLoggedIn() {
            Network.shared.checkForProfile { (bool) in
                if !bool {
                    self.performSegue(withIdentifier: "MissingProfile", sender: self)
                }
            }
            
            Network.shared.getMyName { (result) in
                if let name = try? result.get() {
                    self.nameLabel.text = name
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
