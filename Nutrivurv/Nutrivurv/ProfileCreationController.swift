//
//  ProfileCreationController.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ProfileCreationController {
    
    // MARK: - Properties
    var userProfile: UserProfile?
    
    static var birthDate: String?
    static var weight: Int?
    static var biologicalSex: BiologicalSex.RawValue?
    static var goalWeight: Int?
    static var activityLevel: Int?

    var bmi: String? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .bmiUpdated, object: nil)
            }
        }
    }
    
    // MARK: - Default Data
    
    var activityLevels: [ActivityLevel] = [
        ActivityLevel(level: 2, name: "Not Very Active", description: "Spends most of the day sitting (little to no exercise)"),
        ActivityLevel(level: 3, name: "Lightly Active", description: "Spends a good part of the day on your feet (light exercise 1-3 days/week)"),
        ActivityLevel(level: 4, name: "Active", description: "Spends a good part of the day doing some physical activity (moderate exercise  3-5 days/week)"),
        ActivityLevel(level: 5, name: "Very Active", description: "Spends most of the day doing heavy phyysical activity (very strenous excersice or physical job daily)"),
        ActivityLevel(level: 1, name: "Sedentary", description: "Not active at all during the day or requires assistance to perform daily tasks")
    ]
    
    // MARK: - Methods
    
    public func alertEmptyTextField(controller: UIViewController, field: String) {
        let alert = UIAlertController(title: "\(field) is Empty", message: "\(field) is Required. Please fill it out before proceeding.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func toggledSelectedActivityLevel(at indexPath: IndexPath) {
        self.activityLevels[indexPath.row].isSelected.toggle()

        if self.activityLevels[indexPath.row].isSelected {
            ProfileCreationController.activityLevel = self.activityLevels[indexPath.row].level
        }
    }
    
    func showInfo(at indexPath: IndexPath) {
        print("You just tapped the Info button for row: \(indexPath.row)")
    }
}
