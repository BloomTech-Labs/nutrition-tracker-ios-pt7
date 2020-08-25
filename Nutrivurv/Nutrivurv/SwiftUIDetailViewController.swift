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

class SwiftUIDetailViewController: UIHostingController<FoodDetailView>, FoodLogDelegate {
    
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
        
        super.init(coder: aDecoder, rootView: FoodDetailView(currentDailyMacros: currentMacros, newDailyMacros: newMacros, foodItemMacros: DailyMacros(), nutritionFacts: NutritionFacts(), servingSizes: ServingSizes(), delegate: FoodDetailViewDelegate()))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        rootView.foodLogDelegate = self
        
        if foodLogEntry != nil {
            setupViewForExistingEntry()
            rootView.delegate.newEntry = false
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
    
    // Method that establishes protocol conformance to the FoodLogDelegate - Called from SwiftUI Button on detail view
    func addNewMeal() {
        guard let foodItem = foodItem else {
            print("No food item when attempting to log new entry")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let meal = rootView.delegate.mealTypeName.lowercased()
        
        let edamamfoodID = foodItem.food.foodId
        
        let measurementName = rootView.delegate.servingSizeName
        let measurementIndex = rootView.delegate.servingSizeIndex
        let measurementURI = foodItem.measures[measurementIndex].uri
        
        let foodName = foodItem.food.label.capitalized
        
        let quantity = rootView.delegate.quantity
        guard let quantityDouble = Double(quantity) else {
            print("User entered quantity not a number")
            return
        }
        guard quantityDouble > 0 else {
            // TODO: - Alert user that to input a value greater than 0
            return
        }
        
        let calories = Int(rootView.nutritionFacts.calories)
        let carbs = String(rootView.nutritionFacts.totalCarb.roundToDecimal(2))
        let protein = String(rootView.nutritionFacts.protein.roundToDecimal(2))
        let fat = String(rootView.nutritionFacts.totalFat.roundToDecimal(2))
        
        let imageURL = foodItem.food.image
        
        var allMeasurements: [Measurement] = []
        for measure in rootView.servingSizes.edamamMeasures {
            let measurement = Measurement(uri: measure.uri, label: measure.label)
            allMeasurements.append(measurement)
        }
        
        let newEntry = FoodLogEntry(date: dateString, mealType: meal, foodID: edamamfoodID, measurementURI: measurementURI, measurementName: measurementName, allMeasurements: allMeasurements, foodName: foodName, quantity: quantity, calories: calories, fat: fat, carbs: carbs, protein: protein, imageURL: imageURL)
        
        FoodLogController.shared.createFoodLogEntry(entry: newEntry) { (response) in
            switch response {
            case .success(true):
                print("Successfully logged entry")
                
                NotificationCenter.default.post(name: .newFoodItemLogged, object: nil)
                
                if calories > 0 {
                    HealthKitController.shared.saveCalorieIntakeSample(calories: Double(calories))
                }
                HealthKitController.shared.updateAllValues()
                return
            case .failure(let error):
                if error == .badAuth || error == .noAuth {
                    // TODO - Reauthorize user
                } else {
                    print("Error reauthorizing user and updating food log")
                    return
                }
            default:
                print("General error occured while atttempting to log new entry")
                return
            }
        }
    }
    
    private func updateMacrosForExistingEntry() {
        guard let foodLogEntry = foodLogEntry else { return }
        
        rootView.foodItemMacros.caloriesCount = CGFloat(foodLogEntry.calories)
        rootView.newDailyMacros.caloriesCount = rootView.currentDailyMacros.caloriesCount - rootView.foodItemMacros.caloriesCount
        if let caloriesBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.caloricBudget.rawValue) as? Double {
            // New macros containing the current daily progress + this item
            let caloriePct = (rootView.newDailyMacros.caloriesCount / CGFloat(caloriesBudget)) * 100
            rootView.newDailyMacros.caloriesPercent = caloriePct
        }
        
        if let carbsCount = Double(foodLogEntry.carbs) {
            rootView.foodItemMacros.carbsCount = CGFloat(carbsCount)
            rootView.newDailyMacros.carbsCount = rootView.currentDailyMacros.carbsCount - rootView.foodItemMacros.carbsCount
            if let carbsBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.carbsBudget.rawValue) as? Double {
                let carbPct = (rootView.newDailyMacros.carbsCount / CGFloat(carbsBudget)) * 100
                rootView.newDailyMacros.carbsPercent = carbPct
            }
        }
        
        if let proteinCount = Double(foodLogEntry.protein) {
            rootView.foodItemMacros.proteinCount = CGFloat(proteinCount)
            rootView.newDailyMacros.proteinCount = rootView.currentDailyMacros.proteinCount - rootView.foodItemMacros.proteinCount
            if let proteinBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.proteinBudget.rawValue) as? Double {
                let proteinPct = (rootView.newDailyMacros.proteinCount / CGFloat(proteinBudget)) * 100
                rootView.newDailyMacros.proteinPercent = proteinPct
            }
        }
        
        if let fatCount = Double(foodLogEntry.fat) {
            rootView.foodItemMacros.fatCount = CGFloat(fatCount)
            rootView.newDailyMacros.fatCount = rootView.currentDailyMacros.fatCount - rootView.foodItemMacros.fatCount
            if let fatBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.fatBudget.rawValue) as? Double {
                let fatPct = (rootView.newDailyMacros.fatCount / CGFloat(fatBudget)) * 100
                rootView.newDailyMacros.fatPercent = fatPct
            }
        }
    }
    
    private func updateMacrosForNewEntry() {
        if let calories = nutrients?.calories {
            rootView.foodItemMacros.caloriesCount = CGFloat(calories)
            rootView.newDailyMacros.caloriesCount = rootView.currentDailyMacros.caloriesCount + rootView.foodItemMacros.caloriesCount
            if let caloriesBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.caloricBudget.rawValue) as? Double {
                // New macros containing the current daily progress + this item
                let caloriePct = (rootView.newDailyMacros.caloriesCount / CGFloat(caloriesBudget)) * 100
                rootView.newDailyMacros.caloriesPercent = caloriePct
            }
        }
        
        if let carbs = nutrients?.totalNutrients.CHOCDF?.quantity {
            let carbsDouble = Double(carbs)
            rootView.foodItemMacros.carbsCount = CGFloat(carbsDouble)
            rootView.newDailyMacros.carbsCount = rootView.currentDailyMacros.carbsCount + rootView.foodItemMacros.carbsCount
            if let carbsBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.carbsBudget.rawValue) as? Double {
                let carbPct = (rootView.newDailyMacros.carbsCount / CGFloat(carbsBudget)) * 100
                rootView.newDailyMacros.carbsPercent = carbPct
            }
        }
        
        if let protein = nutrients?.totalNutrients.PROCNT?.quantity {
            let proteinDouble = Double(protein)
            rootView.foodItemMacros.proteinCount = CGFloat(proteinDouble)
            rootView.newDailyMacros.proteinCount = rootView.currentDailyMacros.proteinCount + rootView.foodItemMacros.proteinCount
            if let proteinBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.proteinBudget.rawValue) as? Double {
                let proteinPct = (rootView.newDailyMacros.proteinCount / CGFloat(proteinBudget)) * 100
                rootView.newDailyMacros.proteinPercent = proteinPct
            }
        }
        
        if let fat = nutrients?.totalNutrients.FAT?.quantity {
            let fatDouble = Double(fat)
            rootView.foodItemMacros.fatCount = CGFloat(fatDouble)
            rootView.newDailyMacros.fatCount = rootView.currentDailyMacros.fatCount + rootView.foodItemMacros.fatCount
            if let fatBudget = UserDefaults.standard.value(forKey: UserDefaults.Keys.fatBudget.rawValue) as? Double {
                let fatPct = (rootView.newDailyMacros.fatCount / CGFloat(fatBudget)) * 100
                rootView.newDailyMacros.fatPercent = fatPct
            }
        }
    }
    
    private func setupViewForExistingEntry() {
        guard let foodLogEntry = foodLogEntry else {
            print("Food log entry not loaded")
            return
        }
        
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
        
        rootView.delegate.servingSizeName = foodLogEntry.measurementName.capitalized
        rootView.servingSizes.nutrivurvBackendMeasurements = foodLogEntry.allMeasurements
        if let ssIndex = foodLogEntry.allMeasurements.firstIndex(where: {  $0.label.capitalized == foodLogEntry.measurementName }) {
            rootView.delegate.servingSizeIndex = ssIndex
        }
        
        rootView.delegate.mealTypeName = foodLogEntry.mealType.capitalized
        if let mtIndex = MealType.allCases.firstIndex(where: {$0.rawValue == foodLogEntry.mealType.lowercased() }) {
            rootView.delegate.mealTypeIndex = mtIndex
        }
    }
    
    private func setupViewForNewEntry() {
        guard let foodItem = foodItem else {
            print("Food item not loaded")
            return
        }
        
        rootView.navigationBarTitle = "nutrition facts"
        
        if let servingSize = foodItem.measures.first?.label {
            rootView.delegate.servingSizeName = servingSize.capitalized
            rootView.servingSizes.edamamMeasures = foodItem.measures
        }
        
        rootView.delegate.mealTypeName = "Breakfast"
        
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
        
        DispatchQueue.main.async {
            self.rootView.nutritionFacts.isLoading = false
        }
    }
    
    // MARK: - Reauthorize User
    
    private func reauthorizeUser() {
        let alertController = UIAlertController(title: "Session Expired", message: "Your login session has expired. Please enter your email and password to continue using the app, or sign out if desired.", preferredStyle: .alert)

        alertController.addTextField { (email) in
            email.placeholder = "Email"
        }

        alertController.addTextField { (password) in
            password.placeholder = "Password"
        }

        let signOut = UIAlertAction(title: "Sign out", style: .destructive) { (_) in
            self.logoutOfApp()
        }
        let login = UIAlertAction(title: "Reaauthorize", style: .default) { (_) in
            if let textFields = alertController.textFields, let email = textFields[0].text, let pass = textFields[1].text{
                let user = UserAuth(email: email, password: pass)

                UserController.shared.loginUser(user: user) { (result) in
                    if result == .success(true) {
                        self.addNewMeal()
                    } else {
                        print("Error reauthorizing user")
                        return
                    }
                }
            }
        }

        alertController.addAction(signOut)
        alertController.addAction(login)

        self.present(alertController, animated: true)
    }

    private func logoutOfApp() {
        let appHome = UserController.shared.prepareForLogout()

        self.present(appHome, animated: true, completion: nil)
    }
}
