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
    
    var nutritionController: LSLNutritionController?
    var name: String?
    var email: String?
    var password: String?
    var age: String?
    var gender: String?
    var goalWeight: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dietTableView.delegate = self
        self.dietTableView.dataSource = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTrackingMacros" {
            guard let tmVC = segue.destination as? LSLTrackingMacrosViewController else { return }
            
            tmVC.nutritionController = self.nutritionController
            tmVC.name = self.name
            tmVC.email = self.email
            tmVC.password = self.password
            tmVC.age = self.age
            tmVC.gender = self.gender
            tmVC.goalWeight = self.goalWeight
            tmVC.diet = self.nutritionController?.selectedDiets.map({ (diet) -> String in
                return diet.name
            })
        }
    }
}

extension LSLDietaryPreferenceViewController: UITableViewDelegate {
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
                self.nutritionController?.selectedDiets = []
                self.nutritionController?.toggledSelected(at: indexPath)
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
