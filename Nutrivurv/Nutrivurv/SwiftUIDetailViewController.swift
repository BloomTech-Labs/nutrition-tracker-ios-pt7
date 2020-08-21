//
//  SwiftUIDetailViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI

class SwiftUIDetailViewController: UIHostingController<FoodDetailView> {
    
    // Coming from food log
    var foodLogEntry: FoodLogEntry?
    
    // Coming from food search
    var foodItem: FoodItem?
    
    
    required init?(coder aDecoder: NSCoder) {
        let currentMacros = FoodLogController.shared.totalDailyMacrosModel
        let newMacros = DailyMacros()
        
        newMacros.caloriesCount = currentMacros.caloriesCount
        newMacros.caloriesPercent = currentMacros.caloriesPercent
        
        newMacros.carbsCount = currentMacros.carbsCount
        newMacros.carbsPercent = currentMacros.carbsPercent
        
        newMacros.proteinCount = currentMacros.proteinCount
        newMacros.proteinPercent = currentMacros.proteinPercent
        
        newMacros.fatCount = currentMacros.fatCount
        newMacros.fatPercent = currentMacros.fatPercent
        
        super.init(coder: aDecoder, rootView: FoodDetailView(currentDailyMacros: currentMacros, newDailyMacros: newMacros))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        if foodLogEntry != nil {
            setupViewForExistingEntry()
        } else {
            setupViewForNewEntry()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViewForExistingEntry() {
        guard let foodLogEntry = foodLogEntry else {
            print("Food log entry not loaded")
            return
        }
        
        rootView.foodName = foodLogEntry.foodName.capitalized
        rootView.brandName = "Generic Brand"
        
        if let quantity = Double(foodLogEntry.quantity) {
            rootView.quantity = quantity
        }
        
        rootView.servingSize = foodLogEntry.measurementName.capitalized
        
        rootView.mealType = foodLogEntry.mealType.capitalized
    }
    
    private func setupViewForNewEntry() {
        guard let foodItem = foodItem else {
            print("Food item not loaded")
            return
        }
        
        rootView.quantity = 1.0
        if let servingSize = foodItem.measures.first?.label {
            rootView.servingSize = servingSize.capitalized
        }
        rootView.mealType = "Breakfast"
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
