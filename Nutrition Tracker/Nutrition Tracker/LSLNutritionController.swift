//
//  LSLNutritionController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLNutritionController {
    
    // MARK: Properties
    var ages: [String] = ["Under 18", "18-25", "25-30", "30-35", "35-45", "45+"]
    var genders: [String] = ["Male", "Female", "Prefer not to say"]
    var macros: [LSLMacroPreference] = [
        LSLMacroPreference(name: "Carbs"),
        LSLMacroPreference(name: "Fat"),
        LSLMacroPreference(name: "Protein"),
        LSLMacroPreference(name: "None")
    ]
    public var selectedMacros: [LSLMacroPreference] = []
    var diets: [LSLDietPreference] = [
        LSLDietPreference(name: "Keto"),
        LSLDietPreference(name: "Paleo"),
        LSLDietPreference(name: "Vegan"),
        LSLDietPreference(name: "Atkins"),
        LSLDietPreference(name: "Ultra-Low-Fat"),
        LSLDietPreference(name: "US. Gov. Nutrition Guidelines"),
        LSLDietPreference(name: "None")
    ]
    public var selectedDiets: [LSLDietPreference] = []
    
    // MARK: Methods
    
    public func alertEmptyTextField(controller: UIViewController, field: String) {
        let alert = UIAlertController(title: "\(field) is Empty", message: "\(field) is Required. Please fill it out before proceeding.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public func alertUnselectedDiet(controller: UIViewController) {
        let alert = UIAlertController(title: "A Diet has not been selected.", message: "Please select a diet before proceeding.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func toggledSelected(at indexPath: IndexPath) {
        self.diets[indexPath.row].isSelected.toggle()
        
        if self.diets[indexPath.row].isSelected {
            self.selectedDiets.append(self.diets[indexPath.row])
        } else {
            self.selectedDiets.remove(at: indexPath.row)
        }
    }
    
    func toggleChecked(at indexPath: IndexPath) {
        self.macros[indexPath.row].isSelected.toggle()
        
        if self.macros[indexPath.row].isSelected {
            self.selectedMacros.append(self.macros[indexPath.row])
        } else {
            self.selectedMacros.remove(at: indexPath.row)
        }
    }
    
    func showInfo(at indexPath: IndexPath) {
        print("You just tapped the Info button for row: \(indexPath.row)")
    }
}
