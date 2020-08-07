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
        ActivityLevel(level: 1, name: "Sedentary", description: "Not active at all during the day or requires assistance to perform daily tasks"),
        ActivityLevel(level: 2, name: "Not Very Active", description: "Spends most of the day sitting (little to no exercise)"),
        ActivityLevel(level: 3, name: "Lightly Active", description: "Spends a good part of the day on your feet (light exercise 1-3 days/week)"),
        ActivityLevel(level: 4, name: "Active", description: "Spends a good part of the day doing some physical activity (moderate exercise 3-5 days/week)"),
        ActivityLevel(level: 5, name: "Very Active", description: "Spends most of the day doing heavy phyysical activity (very strenous excersice or physical job daily)")
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
            let level = self.activityLevels[indexPath.row].level
            
            // This switch will convert the selected level to the proper mutlipier that is used for calorie/macros calculations on back end
            switch level {
            case 1:
                self.userProfile?.activityLevel = "1.2" // sedentary calculation value
            case 2:
                self.userProfile?.activityLevel = "1.375" // not very active
            case 4:
                self.userProfile?.activityLevel = "1.725" // active
            case 5:
                self.userProfile?.activityLevel = "1.9" // very active
            default:
                self.userProfile?.activityLevel = "1.55" // lightly active
            }
        }
    }
    
    func showInfo(at indexPath: IndexPath) {
        print("You just tapped the Info button for row: \(indexPath.row)")
    }
}
