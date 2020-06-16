//
//  LSLFoodDetailViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLFoodDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var servingSizePickerView: UIPickerView!
    @IBOutlet weak var mealTypePickerView: UIPickerView!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var totalFatMeasureLabel: UILabel!
    @IBOutlet weak var totalFatPercentageLabel: UILabel!
    @IBOutlet weak var sodiumMeasureLabel: UILabel!
    @IBOutlet weak var sodiumPercentageLabel: UILabel!
    @IBOutlet weak var totalCarbsMeasureLabel: UILabel!
    @IBOutlet weak var totalCarbsPercentageLabel: UILabel!
    @IBOutlet weak var cholesterolMeasureLabel: UILabel!
    @IBOutlet weak var cholesterolPercentageLabel: UILabel!
    @IBOutlet weak var sugarMeasureLabel: UILabel!
    @IBOutlet weak var proteinMeasureLabel: UILabel!
    @IBOutlet weak var vitaminDMeasureLabel: UILabel!
    @IBOutlet weak var vitaminDPercentageLabel: UILabel!
    @IBOutlet weak var calciumMeasureLabel: UILabel!
    @IBOutlet weak var calciumPercentageLabel: UILabel!
    @IBOutlet weak var ironMeasureLabel: UILabel!
    @IBOutlet weak var ironPercentageLabel: UILabel!
    @IBOutlet weak var potassiumMeasureLabel: UILabel!
    @IBOutlet weak var potassiumPercentageLabel: UILabel!
    
    
    // MARK: - Properties & Model Controllers
    
    var dailyRecord: DailyLog?
    var searchController: LSLSearchController?
    
    var isTyping: Bool = false
    
    var foodItem: FoodItem? {
        didSet {
            self.getFoodDetails()
            for measure in foodItem!.measures {
                let typeOfMeasure = measure.label
                self.servingSizes.append(typeOfMeasure)
            }
        }
    }
    
    var nutrients: Nutrients? {
        didSet {
            // Since we declared the completion on the main queue in search controller, no need to do it here
            self.updateViews()
        }
    }
    
    var selectedServingSize: Int = 0 {
        didSet {
            self.getFoodDetails()
        }
    }
    
    var quantityInputValue: Double = 1.0 {
        didSet {
            self.getFoodDetails()
        }
    }
    
    var servingSizes: [String] = []
    var mealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qtyTextField.delegate = self
        self.qtyTextField.text = "1.0"

        self.servingSizePickerView.delegate = self
        self.servingSizePickerView.dataSource = self
        
        self.mealTypePickerView.delegate = self
        self.mealTypePickerView.dataSource = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    
    // MARK: - View Setup
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let nutrients = nutrients else { return }
        
        let calories = nutrients.calories
        
        let totalNutrients = nutrients.totalNutrients
        let dailyPercentNutrients = nutrients.totalDaily
        
        let fat = totalNutrients.FAT?.quantity ?? 0
        let fatUnit = totalNutrients.FAT?.unit ?? ""
        let fatPct = dailyPercentNutrients.FAT?.quantity ?? 0
        
        let sodium = totalNutrients.NA?.quantity ?? 0
        let sodiumUnit = totalNutrients.NA?.unit ?? ""
        let sodiumPct = dailyPercentNutrients.NA?.quantity ?? 0
        
        let carbs = totalNutrients.CHOCDF?.quantity ?? 0
        let carbsUnit = totalNutrients.CHOCDF?.unit ?? ""
        let carbsPct = dailyPercentNutrients.CHOCDF?.quantity ?? 0
        
        let chole = totalNutrients.CHOLE?.quantity ?? 0
        let choleUnit = totalNutrients.CHOLE?.unit ?? ""
        let cholePct = dailyPercentNutrients.CHOLE?.quantity ?? 0
        
        let sugar = totalNutrients.SUGAR?.quantity ?? 0
        let sugarUnit = totalNutrients.SUGAR?.unit ?? ""
        
        let protein = totalNutrients.PROCNT?.quantity ?? 0
        let proteinUnit = totalNutrients.PROCNT?.unit ?? ""
        
        let vitD = totalNutrients.VITD?.quantity ?? 0
        let vitDUnit = totalNutrients.VITD?.unit ?? ""
        let vitDPct = dailyPercentNutrients.VITD?.quantity ?? 0
        
        let calcium = totalNutrients.CA?.quantity ?? 0
        let calciumUnit = totalNutrients.CA?.unit ?? ""
        let calciumPct = dailyPercentNutrients.CA?.quantity ?? 0
        
        let iron = totalNutrients.FE?.quantity ?? 0
        let ironUnit = totalNutrients.FE?.unit ?? ""
        let ironPct = dailyPercentNutrients.FE?.quantity ?? 0
        
        let potassium = totalNutrients.K?.quantity ?? 0
        let potassiumUnit = totalNutrients.K?.unit ?? ""
        let potassiumPct = dailyPercentNutrients.K?.quantity ?? 0
        
        calorieLabel.text = "\(calories)"
        
        totalFatMeasureLabel.text = unitStringFor(nutrient: fat, unit: fatUnit)
        totalFatPercentageLabel.text = pctStringFor(nutrient: fatPct)
        
        sodiumMeasureLabel.text = unitStringFor(nutrient: sodium, unit: sodiumUnit)
        sodiumPercentageLabel.text = pctStringFor(nutrient: sodiumPct)
        
        totalCarbsMeasureLabel.text = unitStringFor(nutrient: carbs, unit: carbsUnit)
        totalCarbsPercentageLabel.text = pctStringFor(nutrient: carbsPct)
        
        cholesterolMeasureLabel.text = unitStringFor(nutrient: chole, unit: choleUnit)
        cholesterolPercentageLabel.text = pctStringFor(nutrient: cholePct)
        
        sugarMeasureLabel.text = unitStringFor(nutrient: sugar, unit: sugarUnit)
        
        proteinMeasureLabel.text = unitStringFor(nutrient: protein, unit: proteinUnit)
        
        vitaminDMeasureLabel.text = unitStringFor(nutrient: vitD, unit: vitDUnit)
        vitaminDPercentageLabel.text = pctStringFor(nutrient: vitDPct)
        
        calciumMeasureLabel.text = unitStringFor(nutrient: calcium, unit: calciumUnit)
        calciumPercentageLabel.text = pctStringFor(nutrient: calciumPct)
        
        ironMeasureLabel.text = unitStringFor(nutrient: iron, unit: ironUnit)
        ironPercentageLabel.text = pctStringFor(nutrient: ironPct)
        
        potassiumMeasureLabel.text = unitStringFor(nutrient: potassium, unit: potassiumUnit)
        potassiumPercentageLabel.text = pctStringFor(nutrient: potassiumPct)
    }
    
    
    // MARK: - Helper Functions
    
    private func unitStringFor(nutrient: Double, unit: String) -> String {
        if nutrient == 0 {
            return "-"
        } else {
            let roundedStr = String(format: "%.1f", nutrient)
            return "\(roundedStr) \(unit)"
        }
    }
    
    private func pctStringFor(nutrient: Double) -> String {
        if nutrient == 0 {
            return "0%"
        } else {
            let rounded = Int(nutrient)
            return "\(rounded)%"
        }
    }
    
    @objc func dismissKeyboard() {
        self.qtyTextField.resignFirstResponder()
    }
    
    
    // MARK: - Get Food Details
    
    private func getFoodDetails() {
        guard let foodItem = self.foodItem else { return }
        
        self.searchController?.searchForNutrients(qty: quantityInputValue,
                                                  measure: foodItem.measures[selectedServingSize].uri,
                                                  foodId: foodItem.food.foodId) { (nutrients) in
            guard let nutrients = nutrients else { return }
            print(nutrients)
            self.nutrients = nutrients
        }
    }
    
    
    // MARK: - IBActions & Food Logging
    
    @IBAction func logFood(_ sender: Any) {
        guard let record = self.dailyRecord else { return }
        
        Network.shared.createFoodLog(calories: record.calories, fat: record.fat, carbs: record.carbs, fiber: record.fiber, protein: record.protein, foodString: record.food_string, quantity: record.quantity, mealType: record.meal_type) { (_) in
            print("\(record.food_string) is logged.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func qtyTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text, let double = Double(text) {
            if self.quantityInputValue == double {
                return
            } else {
                 self.quantityInputValue = double
            }
        }
    }
}


// MARK: - Picker View Delegate & Data Source

extension LSLFoodDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == servingSizePickerView {
            let sizeIndex = pickerView.selectedRow(inComponent: 0)
            self.selectedServingSize = sizeIndex
        }
    }
}

extension LSLFoodDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes.count
        case mealTypePickerView:
            return self.mealTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes[row]
        case mealTypePickerView:
            return self.mealTypes[row]
        default:
            return nil
        }
    }
}


// MARK: - Text Field Delegate Methods

extension LSLFoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.qtyTextFieldEditingChanged(textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor(red: 0, green: 0.455, blue: 0.722, alpha: 0.5).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
    }
}
