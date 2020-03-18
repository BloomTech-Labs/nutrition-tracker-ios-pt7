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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dietTableView.delegate = self
        self.dietTableView.dataSource = self
    }
    
    @IBAction func completeProfile(_ sender: CustomButton) {
        guard let age = LSLNutritionController.age else { return } // Required
        guard let weight = LSLNutritionController.weight else { return } // Required
        guard let height = LSLNutritionController.height else { return } // Required
        guard let gender = LSLNutritionController.gender else { return }
        guard let goalWeight = LSLNutritionController.goalWeight else { return }
        guard let activityLevel = LSLNutritionController.activityLevel else { return }
        guard let diet = LSLNutritionController.diet else { return }
                
        Network.shared.apollo.perform(mutation: CreateProfileMutation(data: CreateProfileInput(age: age, weight: weight, height: height, gender: gender, goalWeight: goalWeight, activityLevel: activityLevel, diet: diet))) { [weak self] result in
            switch result {
                case .success(let graphQLResult):
                    if graphQLResult.data?.createProfile.id != nil {
                        self?.performSegue(withIdentifier: "ProfileToDashboard", sender: self)
                    }
                    
                    if let errors = graphQLResult.errors {
                        print("Errors from server: \(errors)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
            }
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
