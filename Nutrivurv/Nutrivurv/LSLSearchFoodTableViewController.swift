//
//  LSLSearchFoodTableViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLSearchFoodTableViewController: UITableViewController {
    
    @IBOutlet weak var foodSearchBar: UISearchBar!
    
    let searchController = LSLSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodSearchBar.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.foodSearchBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.foods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)

        cell.textLabel?.text = self.searchController.foods[indexPath.row].food.label

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let fdVC = segue.destination as? LSLFoodDetailViewController else { return }
            
            let foodItem = self.searchController.foods[indexPath.row]
            fdVC.searchController = self.searchController
            fdVC.foodItem = foodItem
        }
    }
}

extension LSLSearchFoodTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = self.foodSearchBar.text else { return }
        
        // Dismiss Keyboard
        self.foodSearchBar.endEditing(true)
        
        // Perform search for food item
        self.searchController.searchForFoodItem(searchTerm: searchTerm) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
