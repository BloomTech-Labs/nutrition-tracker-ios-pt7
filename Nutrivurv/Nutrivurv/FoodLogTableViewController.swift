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
    let foodSearchController = FoodSearchController()
    
    // A default message label displayed as table view bg view when the users food log is empty for the day
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
        messageLabel.font = UIFont(name: "QuattrocentoSans-Italic", size: 16)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodLogController.shared.foodLog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodLogCell", for: indexPath)
        
        let foodItem = foodLogController.foodLog[indexPath.row]
        
        cell.textLabel?.text = foodItem.foodName.capitalized

        let mealType = foodItem.mealType.capitalized
        cell.detailTextLabel?.text = mealType
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodItem = FoodLogController.shared.foodLog[indexPath.row]

        if let detailVC = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            detailVC.searchController = foodSearchController
            detailVC.foodLogEntry = foodItem
            detailVC.fromLog = true
            detailVC.selectedFoodEntryIndex = indexPath.row
            detailVC.delegate = self
            
            detailVC.title = "Today's \(foodItem.mealType)"
            
            detailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // TODO: Implement another way to delete/reload table view as the food controller didSet is casuing app to crash, as the table view is trying to reload before deleting cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodLogController.foodLog.remove(at: indexPath.row)
        }
    }
}

extension FoodLogTableViewController: EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int) {
        foodLogController.foodLog[index] = entry
    }
}


protocol EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int)
}
