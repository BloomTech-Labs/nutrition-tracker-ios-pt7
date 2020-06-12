//
//  LSLDietaryPreferenceViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLDietaryPreferenceViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var dietTableView: UITableView!
    
    var nutritionController: LSLUserController?
    var createProfileDelegate: CreateProfileCompletionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dietTableView.allowsSelection = false
        self.dietTableView.isScrollEnabled = false
        self.dietTableView.dataSource = self
    }
    
    @IBAction func completeProfile(_ sender: CustomButton) {
        guard LSLUserController.diet != nil else {
            makeSelectionAlert()
            return
        }
        guard let age = LSLUserController.age else { return } // Required
        guard let weight = LSLUserController.weight else { return } // Required
        guard let height = LSLUserController.height else { return } // Required
        guard let gender = LSLUserController.gender else { return } // Optional
        guard let goalWeight = LSLUserController.goalWeight else { return } // Optional
        guard let activityLevel = LSLUserController.activityLevel else { return } // Optional
        guard let diet = LSLUserController.diet else { return } // Optional
        
        Network.shared.createProfile(age: age, weight: weight, height: height, gender: gender, goalWeight: goalWeight, activityLevel: activityLevel, diet: diet) { (result) in
            if result == .success(true) {
                DispatchQueue.main.async {
                    print("User Profile Creation Successful")
                    if self.createProfileDelegate == nil {
                        let destination = UIStoryboard(name: "Dashboard", bundle: .main)
                        guard let dashboardVC = destination.instantiateInitialViewController() as? LSLDashboardViewController else {
                            print("Unable to instantiate dashoboard view controller")
                            self.performSegue(withIdentifier: "ProfileToDashboard", sender: self)
                            return
                        }
                        self.present(dashboardVC, animated: true, completion: nil)
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                        self.createProfileDelegate?.profileWasCreated()
                    }
                }
            } else {
                print("Error - user profile creation was unsuccessful")
            }
        }
    }
    
    // MARK: - AlertControllers
    
    private func makeSelectionAlert() {
        let alertController = UIAlertController(title: "Make a selection", message: "If you folow a specific diet, please select that option, otherwise select \"none\".", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LSLDietaryPreferenceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionController!.diets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryCell", for: indexPath) as? LSLDietTableViewCell else { return UITableViewCell() }
                
        let diet = self.nutritionController!.diets[indexPath.row]
        cell.diet = diet
        cell.delegate = self
        
        return cell
    }
}

extension LSLDietaryPreferenceViewController: LSLDietTableViewCellDelegate {
    func tappedRadioButton(on cell: LSLDietTableViewCell) {
        guard let indexPath = self.dietTableView.indexPath(for: cell) else { return }
        
        for i in 0 ..< self.nutritionController!.diets.count {
            if i != indexPath.row {
                self.nutritionController?.diets[i].isSelected = false
            } else {
                self.nutritionController?.toggledSelectedDiet(at: indexPath)
            }
        }
        self.dietTableView.reloadData()
    }
    
    func tappedInfoButton(on cell: LSLDietTableViewCell) {
        guard let indexPath = self.dietTableView.indexPath(for: cell) else { return }
        
        self.nutritionController?.showInfo(at: indexPath)
        self.dietTableView.reloadData()
    }
}
