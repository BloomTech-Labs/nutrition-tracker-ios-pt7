//
//  LSLUserController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLUserController {
    
    // MARK: - Properties
    
    static var age: Int?
    static var weight: Int?
    static var height: Int?
    static var gender: Bool?
    static var goalWeight: Int?
    static var activityLevel: Int?
    static var diet: String?

    static var bmi: String? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .bmiUpdated, object: nil)
            }
        }
    }
    
    // MARK: - Default Data
    
    var ages: [String] = ["Prefer not to say", "Under 18", "18-25", "25-30", "30-35", "35-45", "45+"]
    var genders: [String] = ["Prefer not to say", "Male", "Female"]
    var activityLevels: [ActivityLevel] = [
        ActivityLevel(level: 2, name: "Not Very Active", description: "Spend most of the day sitting (little to no exercise)"),
        ActivityLevel(level: 3, name: "Lightly Active", description: "Spend a good part of the day on your feet (light exercise 1-3 days/week)"),
        ActivityLevel(level: 4, name: "Active", description: "Spend a good part of the day doing some physical activity (moderate exercise  3-5 days/week)"),
        ActivityLevel(level: 5, name: "Very Active", description: "Spends most of the day doing heavy phyysical activity (very strenous excersice or physical job daily)"),
        ActivityLevel(level: 1, name: "None / Custom", description: "Nothing here")
    ]
    var diets: [Diet] = [
        Diet(name: "Keto"),
        Diet(name: "Paleo"),
        Diet(name: "Vegan"),
        Diet(name: "Atkins"),
        Diet(name: "Ultra-Low-Fat"),
        Diet(name: "US. Gov. Nutrition Guidelines"),
        Diet(name: "None")
    ]
    
    // MARK: - Methods
    
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
    
    func toggledSelectedDiet(at indexPath: IndexPath) {
        self.diets[indexPath.row].isSelected.toggle()

        if self.diets[indexPath.row].isSelected {
            LSLUserController.diet = self.diets[indexPath.row].name
        }
    }
    
    func toggledSelectedActivityLevel(at indexPath: IndexPath) {
        self.activityLevels[indexPath.row].isSelected.toggle()

        if self.activityLevels[indexPath.row].isSelected {
            LSLUserController.activityLevel = self.activityLevels[indexPath.row].level
        }
    }
    
    func showInfo(at indexPath: IndexPath) {
        print("You just tapped the Info button for row: \(indexPath.row)")
    }
}
