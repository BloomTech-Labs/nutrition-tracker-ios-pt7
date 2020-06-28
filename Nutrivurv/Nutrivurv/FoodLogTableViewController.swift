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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFoodLogTableView), name: .newFoodItemLogged, object: nil)
    }
    
    @objc func reloadFoodLogTableView() {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if foodLogController.foodLog.isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            reloadFoodLogTableView()
        }
    }
    
    // MARK: - Table view data source
    
    // Will be used in future to separate meal types into different sections of tableview
    /*    override func numberOfSections(in tableView: UITableView) -> Int {
     let mealCount = FoodLogController.shared.foodLogDictionary.keys.count
     return mealCount
     }
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodLogController.foodLog.count
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
            detailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    private func getMealTypeNameFor(_ int: Int) -> String? {
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}