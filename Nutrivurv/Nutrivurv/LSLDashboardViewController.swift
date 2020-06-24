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
    
    var dashboardController = LSLDashboardController()
    var userController = LSLUserController()
    
    // MARK: - View Lifecycle Methods and Update Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        
        if AuthController.isLoggedIn() {
            self.title = "Welcome!"
            self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
        } else {
            self.logoutButtonTapped(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let keychain = KeychainSwift()
        keychain.clear()
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "MainAppWelcome") as! UINavigationController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        self.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Profile Laod and Update
    
//    private func checkForProfile() {
//        dashboardController.checkForProfile { (hasProfile) in
//            if hasProfile {
//                DispatchQueue.main.async {
//                    self.loadProfile()
//                }
//            } else {
//                let destination = UIStoryboard(name: "Profile", bundle: .main)
//                guard let profileCreationVC = destination.instantiateInitialViewController() as? LSLCalculateBMIViewController else {
//                    print("Unable to instantiate profile creation view controller")
//                    return
//                }
//                profileCreationVC.createProfileDelegate = self
//                profileCreationVC.nutritionController = self.userController
//                self.navigationController?.pushViewController(profileCreationVC, animated: true)
//            }
//        }
//    }
    
//    private func loadProfile() {
//        self.dashboardController.getMyName { (result) in
//            if let name = try? result.get() {
//                self.navigationItem.title = name
//            } else {
//                print("Couldn't get name: \(result)")
//            }
//        }
//
//        self.dashboardController.getMyWeight { (result) in
//            if let weight = try? result.get() {
//                self.currentWeightLabel.text = String(weight)
//            } else {
//                if let weight = LSLUserController.weight {
//                    self.currentWeightLabel.text = String(weight)
//                } else {
//                    print("Unable to load weight for user")
//                }
//            }
//        }
//    }
}

// MARK: - Profile Completion Protocol Declaration & Delegate Conformance

extension LSLDashboardViewController: CreateProfileCompletionDelegate {
    func profileWasCreated() {
//        self.loadProfile()
    }
}

protocol CreateProfileCompletionDelegate {
    func profileWasCreated()
}
