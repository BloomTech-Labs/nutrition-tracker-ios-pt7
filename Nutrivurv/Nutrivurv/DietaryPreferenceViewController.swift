//
//  DietaryPreferenceViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DietaryPreferenceViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var dietTableView: UITableView!
    @IBOutlet weak var completeProfileButton: CustomButton!
    
    var nutritionController: UserController?
    var createProfileDelegate: CreateProfileCompletionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dietTableView.allowsSelection = false
        self.dietTableView.isScrollEnabled = false
        self.dietTableView.dataSource = self
    }
    
    @IBAction func completeProfile(_ sender: CustomButton) {
        // TODO: Implement profile completion functionality once backend has fully implemented all functionality
    }
    
    // MARK: - AlertControllers
    
    private func makeSelectionAlert() {
        createAndDisplayAlertController(title: "Make a selection", message: "If you follow a specific diet, please select that option, otherwise select \"none\".")
    }
    
    private func tryAgainAlert() {
        createAndDisplayAlertController(title: "Please Try Again", message: "Hmm.. we weren't able to create your profile. Please try again.")
    }
    
    private func missingInformationAlert() {
        createAndDisplayAlertController(title: "Missing Information", message: "It looks like we're missing some information needed to create your profile. Please go back and ensure everything is completed.")
    }
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source Methods

extension DietaryPreferenceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionController!.diets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryCell", for: indexPath) as? DietaryPreferenceTableViewCell else { return UITableViewCell() }
                
        let diet = self.nutritionController!.diets[indexPath.row]
        cell.diet = diet
        cell.delegate = self
        
        return cell
    }
}

// MARK: - Custom Delegate Methods for Updated Dietary Preference Selection

extension DietaryPreferenceViewController: DietaryPreferenceCellDelegate {
    func tappedRadioButton(on cell: DietaryPreferenceTableViewCell) {
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
    
    func tappedInfoButton(on cell: DietaryPreferenceTableViewCell) {
        guard let indexPath = self.dietTableView.indexPath(for: cell) else { return }
        
        self.nutritionController?.showInfo(at: indexPath)
        self.dietTableView.reloadData()
    }
}
