//
//  LSLActivityLevelViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLActivityLevelViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var activeTableView: UITableView!
    
    var nutritionController: LSLUserController?
    var createProfileDelegate: CreateProfileCompletionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activeTableView.allowsSelection = false
        self.activeTableView.isScrollEnabled = false
    
        self.activeTableView.dataSource = self
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func ToDietaryPreference(_ sender: Any) {
        guard LSLUserController.activityLevel != nil else {
            makeSelectionAlert()
            return
        }
        self.performSegue(withIdentifier: "ToDietPreference", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDietPreference" {
            guard let dpVC = segue.destination as? LSLDietaryPreferenceViewController else { return }
            dpVC.nutritionController = self.nutritionController
            dpVC.createProfileDelegate = self.createProfileDelegate
        }
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

extension LSLActivityLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionController!.activityLevels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath) as? LSLActiveTableViewCell else { return UITableViewCell() }
               
        let activityLevel = self.nutritionController?.activityLevels[indexPath.row]
        cell.activityLevel = activityLevel
        cell.delegate = self
        
        if LSLUserController.activityLevel == indexPath.row {
            cell.activeRadioButton.isSelected = true
        }
        
        return cell
    }
}

// MARK: - Custom Delegate Methods for Updated Activity Level Selection

extension LSLActivityLevelViewController: LSLActiveTableViewCellDelegate {
    func tappedRadioButton(on cell: LSLActiveTableViewCell) {
        guard let indexPath = self.activeTableView.indexPath(for: cell) else { return }

        for i in 0 ..< self.nutritionController!.activityLevels.count {
            if i != indexPath.row {
                self.nutritionController?.activityLevels[i].isSelected = false
            } else {
                self.nutritionController?.toggledSelectedActivityLevel(at: indexPath)
            }
        }
        self.activeTableView.reloadData()
    }
}
