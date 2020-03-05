//
//  LSLTrackingMacrosViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLTrackingMacrosViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var macrosTableView: UITableView!
    
    var nutritionController: LSLNutritionController?
    var name: String?
    var email: String?
    var password: String?
    var age: String?
    var gender: String?
    var goalWeight: String?
    var diet: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.macrosTableView.delegate = self
        self.macrosTableView.dataSource = self
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCalculateBMI" {
            guard let bmiVC = segue.destination as? LSLCalculateBMIViewController else { return }
            
            bmiVC.nutritionController = self.nutritionController
            bmiVC.name = self.name
            bmiVC.email = self.email
            bmiVC.password = self.password
            bmiVC.age = self.age
            bmiVC.gender = self.gender
            bmiVC.goalWeight = self.goalWeight
            bmiVC.diet = self.diet
            bmiVC.macros = self.nutritionController?.selectedMacros.map({ (macro) -> String in
                return macro.name
            })
        }
    }
}

extension LSLTrackingMacrosViewController: UITableViewDelegate {
}

extension LSLTrackingMacrosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionController!.macros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MacroCell", for: indexPath) as? LSLMacroTableViewCell else { return UITableViewCell() }
        
        let macro = self.nutritionController!.macros[indexPath.row]
        cell.macro = macro
        cell.delegate = self
                
        return cell
    }
}

extension LSLTrackingMacrosViewController: LSLMacroTableViewCellDelegate {
    func tappedCheckbox(on cell: LSLMacroTableViewCell) {
        guard let indexPath = self.macrosTableView.indexPath(for: cell) else { return }
        self.nutritionController?.toggleChecked(at: indexPath)
        self.macrosTableView.reloadData()
    }
}
