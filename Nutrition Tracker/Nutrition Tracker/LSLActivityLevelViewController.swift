//
//  LSLActivityLevelViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLActivityLevelViewController: UIViewController {
    
    @IBOutlet var activeTableView: UITableView!
    
    var nutritionController: LSLNutritionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activeTableView.delegate = self
        self.activeTableView.dataSource = self
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func ToDietaryPreference(_ sender: Any) {
        self.performSegue(withIdentifier: "ToDietaryPreference", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDietaryPreference" {
            guard let dpVC = segue.destination as? LSLDietaryPreferenceViewController else { return }
            dpVC.nutritionController = self.nutritionController
        }
    }
}

extension LSLActivityLevelViewController: UITableViewDelegate {
}

extension LSLActivityLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionController!.diets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath) as? LSLActiveTableViewCell else { return UITableViewCell() }
                
        let activityLevel = self.nutritionController!.activityLevels[indexPath.row]
        cell.activityLevel = activityLevel
        cell.delegate = self
        
        return cell
    }
}

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
