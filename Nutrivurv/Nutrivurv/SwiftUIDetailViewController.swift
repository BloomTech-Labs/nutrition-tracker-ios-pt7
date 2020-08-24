//
//  SwiftUIDetailViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import SkeletonUI

class SwiftUIDetailViewController: UIHostingController<FoodDetailView> {
    
    // Coming from food log
    var foodLogEntry: FoodLogEntry?
    
    // Coming from food search
    var foodItem: FoodItem?
    
    var searchController: FoodSearchController?
    
    var nutrients: Nutrients? {
        didSet {
            updateNutritionFactsValues()
            if foodItem != nil {
                updateMacrosForNewEntry()
            }
        }
    }
    
    private var quantitySubscriber: AnyCancellable!
    private var quantity: String = "1.0" {
        didSet {
            fetchNutrientDetails()
        }
    }
    
    private var servingSizeSubscriber: AnyCancellable!
    private var servingSizeIndex: Int = 0 {
        didSet {
            fetchNutrientDetails()
        }
    }
    
    private var mealTypeSubscriber: AnyCancellable!
    private var mealTypeIndex: Int = 0
    
    
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
        
        super.init(coder: aDecoder, rootView: FoodDetailView(currentDailyMacros: currentMacros, newDailyMacros: newMacros, foodItemMacros: DailyMacros(), nutritionFacts: NutritionFacts(), servingSizes: ServingSizes(), delegate: FoodDetailViewDelegate()))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if foodLogEntry != nil {
            setupViewForExistingEntry()
            
            if let imageString = foodLogEntry?.imageURL {
                self.getFoodImage(urlString: imageString)
            }
            
        } else if foodItem != nil {
            setupViewForNewEntry()
            
            if let imageString = foodItem?.food.image {
                self.getFoodImage(urlString: imageString)
            }
            
        } else { return }
        
        self.quantitySubscriber = rootView.delegate.$quantity.sink(receiveValue: { (quantity) in
            self.quantity = quantity
            print(quantity)
        })
        
        self.servingSizeSubscriber = rootView.delegate.$servingSizeIndex.sink(receiveValue: { (index) in
            self.servingSizeIndex = index
            print(index)
        })
        
        self.mealTypeSubscriber = rootView.delegate.$mealTypeIndex.sink(receiveValue: { (index) in
            self.mealTypeIndex = index
            print(index)
        })
    }
    
    private func updateMacrosForExistingEntry() {
        guard let foodLogEntry = foodLogEntry else { return }
        
        rootView.foodItemMacros.caloriesCount = CGFloat(foodLogEntry.calories)
        rootView.newDailyMacros.caloriesCount += rootView.foodItemMacros.caloriesCount
        if let caloriesBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.caloricBudget) as? Double {
            // New macros containing the current daily progress + this item
            let caloriePct = (rootView.newDailyMacros.caloriesCount / CGFloat(caloriesBudget)) * 100
            rootView.newDailyMacros.caloriesPercent = caloriePct
        }
        
        if let carbsCount = Double(foodLogEntry.carbs) {
            rootView.foodItemMacros.carbsCount = CGFloat(carbsCount)
            rootView.newDailyMacros.carbsCount += rootView.foodItemMacros.carbsCount
            if let carbsBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.carbsBudget) as? Double {
                let carbPct = (rootView.newDailyMacros.carbsCount / CGFloat(carbsBudget)) * 100
                rootView.newDailyMacros.carbsPercent = carbPct
            }
        }
        
        if let proteinCount = Double(foodLogEntry.protein) {
            rootView.foodItemMacros.proteinCount = CGFloat(proteinCount)
            rootView.newDailyMacros.proteinCount += rootView.foodItemMacros.proteinCount
            if let proteinBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.proteinBudget) as? Double {
                let proteinPct = (rootView.newDailyMacros.proteinCount / CGFloat(proteinBudget)) * 100
                rootView.newDailyMacros.proteinPercent = proteinPct
            }
        }
        
        if let fatCount = Double(foodLogEntry.fat) {
            rootView.foodItemMacros.fatCount = CGFloat(fatCount)
            rootView.newDailyMacros.fatCount += rootView.foodItemMacros.fatCount
            if let fatBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.fatBudget) as? Double {
                let fatPct = (rootView.newDailyMacros.fatCount / CGFloat(fatBudget)) * 100
                rootView.newDailyMacros.fatPercent = fatPct
            }
        }
    }
    
    private func updateMacrosForNewEntry() {
        if let calories = nutrients?.calories {
            rootView.foodItemMacros.caloriesCount = CGFloat(calories)
        }
        
        if let carbs = nutrients?.totalNutrients.CHOCDF?.quantity {
            let carbsDouble = Double(carbs)
            rootView.foodItemMacros.carbsCount = CGFloat(carbsDouble)
        }
        
        if let protein = nutrients?.totalNutrients.PROCNT?.quantity {
            let proteinDouble = Double(protein)
            rootView.foodItemMacros.proteinCount = CGFloat(proteinDouble)
        }
        
        if let fat = nutrients?.totalNutrients.FAT?.quantity {
            let fatDouble = Double(fat)
            rootView.foodItemMacros.fatCount = CGFloat(fatDouble)
        }
    }
    
    private func setupViewForExistingEntry() {
        guard let foodLogEntry = foodLogEntry else {
            print("Food log entry not loaded")
            return
        }
        
        fetchNutrientDetails()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: foodLogEntry.date) {
            dateFormatter.dateFormat = "E M/d"
            let mealDate = dateFormatter.string(from: date)
            rootView.navigationBarTitle = "\(foodLogEntry.mealType) - \(mealDate)"
        } else {
            rootView.navigationBarTitle = "\(foodLogEntry.mealType) details"
        }

        rootView.foodName = foodLogEntry.foodName.capitalized
        rootView.brandName = "Generic Brand"
        
        updateMacrosForExistingEntry()
        
        rootView.delegate.quantity = foodLogEntry.quantity
        
        rootView.selectedServingSize = foodLogEntry.measurementName.capitalized
        // TODO: - set correct serving size index on delegate
        
        rootView.mealType = foodLogEntry.mealType.capitalized
        // TODO: - Set correct meal type index on delegate
    }
    
    private func setupViewForNewEntry() {
        guard let foodItem = foodItem else {
            print("Food item not loaded")
            return
        }
        
        if let servingSize = foodItem.measures.first?.label {
            rootView.selectedServingSize = servingSize.capitalized
            rootView.servingSizes.measures = foodItem.measures
        }
        
        rootView.mealType = "Breakfast"
        
        rootView.foodName = foodItem.food.label.capitalized
        rootView.brandName = foodItem.food.category
    }
    
    private func getFoodImage(urlString: String) {
        self.searchController?.getFoodImage(urlString: urlString) { (data) in
            guard let data = data else {
                print("Error getting food item image")
                return
            }
            
            if let image = UIImage(data: data) {
                self.rootView.foodImage = image
            }
        }
    }
    
    private func fetchNutrientDetails() {
        rootView.nutritionFacts.isLoading = true
        
        if let foodItem = foodItem {
            print(foodItem)
            
            let servingSizeIndex = self.servingSizeIndex
            let servingSize = foodItem.measures[servingSizeIndex]
            let measureURI = servingSize.uri
            
            guard let quantity = Double(self.quantity) else {
                return
            }
            
            let foodId = foodItem.food.foodId

            self.searchController?.searchForNutrients(qty: quantity, measureURI: measureURI, foodId: foodId) { (nutrients) in
                self.nutrients = nutrients
            }
            
        } else if let foodLogEntry = foodLogEntry {
            let measureURI = foodLogEntry.measurementURI
            let quantityString = foodLogEntry.quantity
            guard let quantity = Double(quantityString) else { return }
            let edamamFoodId = foodLogEntry.foodID
            
            self.searchController?.searchForNutrients(qty: Double(quantity), measureURI: measureURI, foodId: edamamFoodId) { (nutrients) in
                self.nutrients = nutrients
            }
        }
    }
    
    private func updateNutritionFactsValues() {
        guard let nutrients = nutrients else {
            print("Nutrient details failed to load")
            return
        }
        
        let nutrientCounts = nutrients.totalNutrients
        let dailyPcts = nutrients.totalDaily
        
        rootView.nutritionFacts.calories = Double(nutrients.calories)
        
        if let fat = nutrientCounts.FAT?.quantity, let fatPct = dailyPcts.FAT?.quantity {
            rootView.nutritionFacts.totalFat = fat
            rootView.nutritionFacts.totalFatDailyPct = fatPct
        }
        
        if let sodium = nutrientCounts.NA?.quantity, let sodiumPct = dailyPcts.NA?.quantity {
            rootView.nutritionFacts.sodium = sodium
            rootView.nutritionFacts.sodiumDailyPct = sodiumPct
        }
        
        if let carbs = nutrientCounts.CHOCDF?.quantity {
            rootView.nutritionFacts.totalCarb = carbs
        }
        
        if let cholesterol = nutrientCounts.CHOLE?.quantity, let cholesterolPct = dailyPcts.CHOLE?.quantity {
            rootView.nutritionFacts.cholesterol = cholesterol
            rootView.nutritionFacts.cholesterolDailyPct = cholesterolPct
        }
        
        if let sugar = nutrientCounts.SUGAR?.quantity {
            rootView.nutritionFacts.sugar = sugar
        }
        
        if let protein = nutrientCounts.PROCNT?.quantity {
            rootView.nutritionFacts.protein = protein
        }
        
        if let vitaminD = nutrientCounts.VITD?.quantity, let vitDPct = dailyPcts.VITD?.quantity {
            rootView.nutritionFacts.vitaminD = vitaminD
            rootView.nutritionFacts.vitaminDDailyPct = vitDPct
        }
        
        if let calcium = nutrientCounts.CA?.quantity, let calciumPct = dailyPcts.CA?.quantity {
            rootView.nutritionFacts.calcium = calcium
            rootView.nutritionFacts.calciumDailyPct = calciumPct
        }
        
        if let iron = nutrientCounts.FE?.quantity, let ironPct = dailyPcts.FE?.quantity {
            rootView.nutritionFacts.iron = iron
            rootView.nutritionFacts.ironDailyPct = ironPct
        }
        
        if let potassium = nutrientCounts.K?.quantity, let potassiumPct = dailyPcts.K?.quantity {
            rootView.nutritionFacts.potassium = potassium
            rootView.nutritionFacts.potassiumDailyPct = potassiumPct
        }
        
//        let servingSizes = [Measure(uri: "1", label: "Serving"), Measure(uri: "2", label: "Whole"), Measure(uri: "3", label: "Cup"), Measure(uri: "4", label: "Ounce"), Measure(uri: "5", label: "Gram")]
//
//        self.rootView.servingSizes.measures = servingSizes
        
        DispatchQueue.main.async {
            self.rootView.nutritionFacts.isLoading = false
        }
    }
}
