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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodSearchBar.searchTextField.text = foodSearchKeyword
        tableView.reloadData()
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
                let fdVC = segue.destination as? FoodDetailViewController else { return }
            
            let foodItem = self.searchController.foods[indexPath.row]
            fdVC.searchController = self.searchController
            fdVC.foodItem = foodItem
        } else if segue.identifier == "ShowBarcodeScanner" {
            guard let barcodeScanVC = segue.destination as? BarcodeSearchViewController else {
                print("Couldn't load barcode scanner")
                return
            }
            self.searchController.foods = []
            barcodeScanVC.barcodeSearchDelegate = self
            barcodeScanVC.manualSearchDelegate = self
            barcodeScanVC.searchController = self.searchController
        }
    }
    
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func noFoodsFoundAlert() {
        createAndDisplayAlertController(title: "No Foods Found", message: "We weren't able to find any foods matching your search. You may need to specify additional information, such as a brand name. Otherwise you can try scanning the food items barcode to find an exact match.")
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
    }
}

extension FoodSearchTableViewController: BarcodeSearchDelegate {
    func gotResultForFoodFromUPC() {
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
        createAndDisplayAlertController(title: "Manual Search Required", message: "This device cannot be used to scan barcodes. Please search for food items manually. We apologize for the inconvience.")
    }
}


// MARK: - Protocol Definitions

protocol BarcodeSearchDelegate {
    func gotResultForFoodFromUPC()
}

protocol ManualSearchRequiredDelegate {
    func unableToUseBarcodeScanningFeature()
}