//
//  ActivityLevelViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ActivityLevelViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var activeTableView: UITableView!
    
    var profileController: ProfileCreationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activeTableView.allowsSelection = false
        self.activeTableView.isScrollEnabled = false
    
        self.activeTableView.dataSource = self
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let user = profileController?.userProfile else {
            print("User profile missing from registration process")
            return
        }
        
        UserController.shared.registerUser(user: user) { (result) in
            switch result {
            case .success(true):
                print("Successfully registered")
                
                if let tabBarVC = CustomTabBar.getTabBar() {
                    tabBarVC.modalPresentationStyle = .fullScreen
                    tabBarVC.modalTransitionStyle = .coverVertical
                    
                    self.present(tabBarVC, animated: true, completion: nil)
                }
                
            case .failure(.badAuth):
                print("Email already in use")
                let alert = UIAlertController.createAlert(title: "Couldn't Complete Registration", message: "A user account matching your credentials already exists. Please login to your dashboard.", style: .alert)
                let newUserNameAction = UIAlertAction(title: "Choose New Username", style: .default) { (_) in
                    self.chooseNewUsernameAndPassword()
                }
                alert.addAction(newUserNameAction)
                self.present(alert, animated: true)
            default:
                print("Error with registration")
                let alert = UIAlertController.createAlert(title: "Registration Failed", message: "We were unable to create an account for you. Please try again.", style: .alert)
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func chooseNewUsernameAndPassword() {
        let alertController = UIAlertController(title: "Enter New Credentials", message: "The username entered is already in use, please input a new username.", preferredStyle: .alert)
        
        alertController.addTextField { (email) in
            email.placeholder = "Email"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            let appHome = UserController.shared.prepareForLogout()
            self.present(appHome, animated: true)
        }
        
        let createAccount = UIAlertAction(title: "Complete Registration", style: .default) { (_) in
            if let textFields = alertController.textFields, let email = textFields[0].text {
                guard email.isValidEmail() else {
                    let alert = UIAlertController.createAlert(title: "Invalid Email", message: "Please enter a valid email.", style: .alert)
                    self.present(alert, animated: true) {
                        self.chooseNewUsernameAndPassword()
                    }
                    return
                }
                
                self.profileController?.userProfile?.email = email
                
                self.signupButtonTapped(self)
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(createAccount)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - AlertControllers
    
    private func makeSelectionAlert() {
        let alertController = UIAlertController(title: "Make a selection", message: "Please select an activity level in order to continue.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source Methods

extension ActivityLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileController!.activityLevels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath) as? ActivityLevelTableViewCell else { return UITableViewCell() }
               
        let activityLevel = self.profileController?.activityLevels[indexPath.row]
        cell.activityLevel = activityLevel
        cell.delegate = self
        
        if ProfileCreationController.activityLevel == indexPath.row {
            cell.activeRadioButton.isSelected = true
        }
        
        return cell
    }
}

// MARK: - Custom Delegate Methods for Updated Activity Level Selection

extension ActivityLevelViewController: ActivityLevelCellDelegate {
    func tappedRadioButton(on cell: ActivityLevelTableViewCell) {
        guard let indexPath = self.activeTableView.indexPath(for: cell) else { return }

        for i in 0 ..< self.profileController!.activityLevels.count {
            if i != indexPath.row {
                self.profileController?.activityLevels[i].isSelected = false
            } else {
                self.profileController?.toggledSelectedActivityLevel(at: indexPath)
            }
        }
        self.activeTableView.reloadData()
    }
}
