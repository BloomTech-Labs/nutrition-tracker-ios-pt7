//
//  FoodSearchTableViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class FoodSearchTableViewController: UITableViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet weak var foodSearchBar: UISearchBar!
    
    let searchController = FoodSearchController()
    private var searchDelayTimer = Timer()
    
    private var foodSearchKeyword = ""
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodSearchBar.delegate = self
        foodSearchBar.searchTextField.font = UIFont(name: "Catamaran-Medium", size: 14)
        
        // Removes the "back" text from navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        foodSearchBar.searchTextField.text = foodSearchKeyword
        tableView.reloadData()
        
        if let dashboardNavController = self.tabBarController?.viewControllers?.first as? UINavigationController {
            if let dashboardVC = dashboardNavController.viewControllers.first as? DashboardViewController {
                if !Calendar.current.isDateInToday(dashboardVC.selectedDate) {
                    dashboardVC.selectedDate = Date()
                }
            }
        }
    }


    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.foods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)

        cell.textLabel?.text = self.searchController.foods[indexPath.row].food.label.capitalized

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let fdVC = segue.destination as? SwiftUIDetailViewController else { return }
            
            let foodItem = self.searchController.foods[indexPath.row]
            fdVC.searchController = self.searchController
            fdVC.foodItem = foodItem
            fdVC.modalPresentationStyle = .fullScreen
        } else if segue.identifier == "ShowBarcodeScanner" {
            guard let barcodeScanVC = segue.destination as? BarcodeSearchViewController else {
                print("Couldn't load barcode scanner")
                return
            }
            self.foodSearchBar.searchTextField.resignFirstResponder()
            barcodeScanVC.barcodeSearchDelegate = self
            barcodeScanVC.manualSearchDelegate = self
            barcodeScanVC.searchController = self.searchController
        }
    }
    
    
    // MARK: - Alert Controllers
    
    private func noFoodsFoundAlert() {
        let alert = UIAlertController.createAlert(title: "No Foods Found", message: "We weren't able to find any foods matching your search. You may need to specify additional information, such as a brand name. Otherwise you can try scanning the food items barcode to find an exact match.", style: .alert)
        self.present(alert, animated: true)
    }
    
    private func generalNetworkingErrorAlert() {
        let alert = UIAlertController.createAlert(title: "Search Not Available", message: "We were unable to complete a search for the food item. Please check your internet connection and try again.", style: .alert)
        self.present(alert, animated: true)
    }
    
    // MARK: - Helper Search Function
    
    @objc func delayedSearch() {
        guard let searchText = searchDelayTimer.userInfo as? String, !searchText.isEmpty else { return }
        searchDelayTimer.invalidate()
        
        if foodSearchKeyword == searchText {
            return
        } else {
            foodSearchKeyword = searchText
        }
        
        searchController.searchForFoodItemWithKeyword(searchTerm: searchText) { (error) in
            if let error = error as? NetworkError {
                if error == .noDecode {
                    self.noFoodsFoundAlert()
                } else if error == .otherError {
                    self.generalNetworkingErrorAlert()
                }
                return
            }
            
            self.tableView.reloadData()
        }
    }
}


// MARK: - Protocol Conformance & Delegate Methods

extension FoodSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = self.foodSearchBar.text else { return }
        
        foodSearchBar.endEditing(true)
        foodSearchBar.showsCancelButton = false
        searchDelayTimer.invalidate()
        
        if foodSearchKeyword == searchTerm {
            return
        } else {
            foodSearchKeyword = searchTerm
        }
        
        searchController.searchForFoodItemWithKeyword(searchTerm: searchTerm) { (error) in
            if let error = error as? NetworkError {
                if error == .noDecode {
                    self.noFoodsFoundAlert()
                } else if error == .otherError {
                    self.generalNetworkingErrorAlert()
                }
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDelayTimer.invalidate()
        foodSearchBar.showsCancelButton = false
        foodSearchKeyword = ""
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            foodSearchKeyword = ""
            return
        }
        
        searchDelayTimer.invalidate()
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.delayedSearch), userInfo: searchText, repeats: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        foodSearchBar.showsCancelButton = true
        searchBar.searchTextField.layer.borderWidth = 2.0
        searchBar.searchTextField.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.shadowColor = UIColor(red: 0, green: 0.455, blue: 0.722, alpha: 0.5).cgColor
        searchBar.searchTextField.layer.shadowOpacity = 1
        searchBar.searchTextField.layer.shadowRadius = 4
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.layer.borderWidth = 0
        searchBar.searchTextField.layer.shadowOpacity = 0
    }
}

extension FoodSearchTableViewController: BarcodeSearchDelegate {
    func gotResultForFoodFromUPC() {
        self.foodSearchBar.text = searchController.foods.first?.food.label.capitalized
        tableView.reloadData()
    }
}

extension FoodSearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchDelayTimer.invalidate()
        textField.resignFirstResponder()
        return true
    }
}

extension FoodSearchTableViewController: ManualSearchRequiredDelegate {
    func unableToUseBarcodeScanningFeature() {
        let alert = UIAlertController.createAlert(title: "Manual Search Required", message: "This device cannot be used to scan barcodes. Please search for food items manually. We apologize for the inconvience.", style: .alert)
        self.present(alert, animated: true)
    }
}


// MARK: - Protocol Definitions

protocol BarcodeSearchDelegate {
    func gotResultForFoodFromUPC()
}

protocol ManualSearchRequiredDelegate {
    func unableToUseBarcodeScanningFeature()
}
