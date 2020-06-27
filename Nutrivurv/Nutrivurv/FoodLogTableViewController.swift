//
//  FoodLogTableViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class FoodLogTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFoodLogTableView), name: .newFoodItemLogged, object: nil)
    }
    
    @objc func reloadFoodLogTableView() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    // Will be used in future to separate meal types into different sections of tableview
/*    override func numberOfSections(in tableView: UITableView) -> Int {
          let mealCount = FoodLogController.shared.foodLogDictionary.keys.count
          return mealCount
      }
*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodLogController.shared.foodLog.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodLogCell", for: indexPath)
        
        let foodItem = FoodLogController.shared.foodLog[indexPath.row]
        
        cell.textLabel?.text = foodItem.food.label
        cell.detailTextLabel?.text = foodItem.mealType

        return cell
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
