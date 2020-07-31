//
//  FoodLogTableViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class FoodLogTableViewController: UITableViewController {
    
    let foodLogController = FoodLogController.shared
    var foodLog: FoodLog? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let foodSearchController = FoodSearchController()
    
    // A default message label displayed as table view bg view when the users food log is empty for the day
    var noFoodLoggedLabel: UILabel?
    
    var selectedDateForLogs: String? {
        didSet {
            self.updateFoodLog()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFoodLog), name: .newFoodItemLogged, object: nil)
        self.setDateForLogEntries()
    }
    
    @objc func reloadFoodLogTableView() {
        if foodLogIsEmpty() {
            noFoodLoggedMessage(message: "You haven't logged any foods yet,\n tap the utensils icon below to get started!")
        } else {
            tableView.backgroundView = .none
            tableView.separatorStyle = .singleLine
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFoodLogTableView()
    }
    
    private func setDateForLogEntries() {
        // TODO: Allow user to visit previous calendar dates to get log for that date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.selectedDateForLogs = dateFormatter.string(from: date)
    }
    
    private func noFoodLoggedMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "nutrivurv-blue")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "QuattrocentoSans-Italic", size: 16)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MealType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let foodLog = foodLog else { return 0 }
        
        switch section {
        case 0:
            if let breakfast = foodLog.breakfast {
                return breakfast.count
            }
        case 1:
            if let lunch = foodLog.lunch {
                return lunch.count
            }
        case 2:
            if let dinner = foodLog.dinner {
                return dinner.count
            }
        case 3:
            if let snack = foodLog.snack {
                return snack.count
            }
        case 4:
            if let water = foodLog.water {
                return water.count
            }
        default:
            break
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let foodLog = foodLog else { return nil }
        
        let label = MealTypeHeaderLabel()
        
        switch section {
            case 0:
                if foodLog.breakfast != nil {
                    label.text = "Breakfast"
                }
            case 1:
                if foodLog.lunch != nil {
                    label.text = "Lunch"
                }
            case 2:
                if foodLog.dinner != nil {
                    label.text = "Dinner"
                }
            case 3:
                if foodLog.snack != nil {
                    label.text = "Snacks"
                }
            case 4:
                if foodLog.water != nil {
                    label.text = "Water"
                }
            default:
                label.text = nil
        }
        
        if label.text == nil {
            return nil
        }
        
        let containerView = UIView()
        containerView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12).isActive = true
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 4.5
        containerView.layer.shadowOffset = CGSize(width: 1.5, height: 2.5)
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let foodLog = foodLog else { return 0 }
        var headerSize: CGFloat = 0.001
        
        switch section {
            case 0:
                if foodLog.breakfast != nil {
                    headerSize = 60
                }
            case 1:
                if foodLog.lunch != nil {
                    headerSize = 60
                }
            case 2:
                if foodLog.dinner != nil {
                    headerSize = 60
                }
            case 3:
                if foodLog.snack != nil {
                    headerSize = 60
                }
            case 4:
                if foodLog.water != nil {
                    headerSize = 60
                }
            default:
                return 0.001
        }
        
        return headerSize
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodLogCell", for: indexPath)
        
        guard let foodLog = foodLog else { return cell }
        
        switch indexPath.section {
        case 0:
            if let breakfast = foodLog.breakfast {
                let breakfastEntry = breakfast[indexPath.row]
                cell.textLabel?.text = breakfastEntry.foodName.capitalized
                cell.detailTextLabel?.text = breakfastEntry.mealType.capitalized
            }
        case 1:
            if let allLunch = foodLog.lunch {
                let lunchEntry = allLunch[indexPath.row]
                cell.textLabel?.text = lunchEntry.foodName.capitalized
                cell.detailTextLabel?.text = lunchEntry.mealType.capitalized
            }
        case 2:
            if let allDinner = foodLog.dinner {
                let dinnerEntry = allDinner[indexPath.row]
                cell.textLabel?.text = dinnerEntry.foodName.capitalized
                cell.detailTextLabel?.text = dinnerEntry.mealType.capitalized
            }
        case 3:
            if let allSnacks = foodLog.snack {
                let snackEntry = allSnacks[indexPath.row]
                cell.textLabel?.text = snackEntry.foodName.capitalized
                cell.detailTextLabel?.text = snackEntry.mealType.capitalized
            }
        case 4:
            if let allWater = foodLog.water {
                let waterEntry = allWater[indexPath.row]
                cell.textLabel?.text = waterEntry.foodName.capitalized
                cell.detailTextLabel?.text = waterEntry.mealType.capitalized
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let foodLog = foodLog, !foodLogIsEmpty() else { return }
        
        var foodEntry: FoodLogEntry?
        
        switch indexPath.section {
        case 0:
            if let breakfast = foodLog.breakfast {
                foodEntry = breakfast[indexPath.row]
            }
        case 1:
            if let allLunch = foodLog.lunch {
                foodEntry = allLunch[indexPath.row]
            }
        case 2:
            if let allDinner = foodLog.dinner {
                foodEntry = allDinner[indexPath.row]
            }
        case 3:
            if let allSnacks = foodLog.snack {
                foodEntry = allSnacks[indexPath.row]
            }
        case 4:
            if let allWater = foodLog.water {
                foodEntry = allWater[indexPath.row]
            }
        default:
            foodEntry = nil
        }

        guard let entry = foodEntry else { return }
        
        if let detailVC = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            detailVC.searchController = foodSearchController
            detailVC.foodLogEntry = entry
            detailVC.fromLog = true
            detailVC.selectedFoodEntryIndex = indexPath.row
            detailVC.delegate = self
            
            detailVC.title = "Today's \(entry.mealType.capitalized)"
            
            detailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // TODO: Implement another way to delete/reload table view as the food controller didSet is casuing app to crash, as the table view is trying to reload before deleting cell
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            foodLogController.foodLog.remove(at: indexPath.row)
//        }
//    }
    
    
    private func getEntriesByMeal(mealType: FoodLogEntry) {
        
    }
    
    private func foodLogIsEmpty() -> Bool {
        guard let foodLog = foodLog else { return true }
        return foodLog.breakfast == nil && foodLog.lunch == nil && foodLog.dinner == nil && foodLog.snack == nil && foodLog.water == nil
    }
    
    
    @objc private func updateFoodLog() {
        guard let date = selectedDateForLogs else { return }
        
        FoodLogController.shared.getFoodLogEntriesForDate(date: date) { (result) in
            switch result {
            case .success(let foodLog):
                self.foodLog = foodLog
                self.tableView.reloadData()
                self.reloadFoodLogTableView()
            default:
                return
            }
        }
    }
    
}

extension FoodLogTableViewController: EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int) {
//        foodLogController.foodLog[index] = entry
    }
}


protocol EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int)
}
