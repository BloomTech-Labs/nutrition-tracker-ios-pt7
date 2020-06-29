//
//  FoodLogTableViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class FoodLogTableViewController: UITableViewController {
    
    let foodLogController = FoodLogController.shared
    let foodSearchController = FoodSearchController()
    
    var noFoodLoggedLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFoodLogTableView), name: .newFoodItemLogged, object: nil)
    }
    
    @objc func reloadFoodLogTableView() {
        self.tableView.reloadData()
        if foodLogController.foodLog.isEmpty {
            noFoodLoggedMessage(message: "You haven't logged any foods today,\n let's get started!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if foodLogController.foodLog.isEmpty {
            noFoodLoggedMessage(message: "You haven't logged any foods yet,\n tap the utensils icon below to get started!")
        } else {
            tableView.backgroundView = .none
            tableView.separatorStyle = .singleLine
            reloadFoodLogTableView()
        }
    }
    
    
    private func noFoodLoggedMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "nutrivurv-blue")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Muli-LightItalic", size: 16)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    
/*  Will be used in future to separate meal types into different sections of tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FoodLogController.shared.mealTypes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let count = FoodLogController.shared.foodLog.filter { $0.mealType == 0 }.count
            return count
        case 1:
            return FoodLogController.shared.foodLog.filter { $0.mealType == 1 }.count
        case 2:
            return FoodLogController.shared.foodLog.filter { $0.mealType == 2 }.count
        case 3:
            return FoodLogController.shared.foodLog.filter { $0.mealType == 3 }.count
        default:
            return FoodLogController.shared.foodLog.filter { $0.mealType == 4 }.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Breakfast"
        case 1:
            return "Lunch"
        case 2:
            return "Dinner"
        case 3:
            return "Dessert"
        default:
            return "Snack"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Return 0 to disable the section title.
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodLogController.shared.foodLog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodLogCell", for: indexPath)
        
        let foodItem = foodLogController.foodLog[indexPath.row]
        
        cell.textLabel?.text = foodItem.food.label.capitalized

        if let mealIndex = foodItem.mealType {
            let mealType = getMealTypeNameFor(mealIndex)
            cell.detailTextLabel?.text = mealType
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodItem = FoodLogController.shared.foodLog[indexPath.row]

        if let detailVC = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            detailVC.searchController = foodSearchController
            detailVC.foodItem = foodItem
            detailVC.fromLog = true
            if let meal = getMealTypeNameFor(foodItem.mealType) {
                detailVC.title = "Today's \(meal)"
            }
            detailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    private func getMealTypeNameFor(_ int: Int?) -> String? {
        switch int {
        case 0:
            return "Breakfast"
        case 1:
            return "Lunch"
        case 2:
            return "Dinner"
        case 3:
            return "Dessert"
        case 4:
            return "Snack"
        default:
            return nil
        }
    }
    
    // TODO: Implement another way to delete/reload table view as the food controller didSet is casuing app to crash, as the table view is trying to reload before deleting cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodLogController.foodLog.remove(at: indexPath.row)
        }
    }
}
