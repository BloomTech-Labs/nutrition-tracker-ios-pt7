//
//  LSLFoodDetailViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLFoodDetailViewController: UIViewController {
    
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
    
    var quantityInputValue: Int = 1 {
        didSet {
            self.getFoodDetails()
        }
    }
    
    var servingSizes: [String] = []
    var mealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qtyTextField.delegate = self
        self.qtyTextField.text = "1"

        self.servingSizePickerView.delegate = self
        self.servingSizePickerView.dataSource = self
        
        self.mealTypePickerView.delegate = self
        self.mealTypePickerView.dataSource = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.qtyTextField.resignFirstResponder()
    }
    
    private func formatNumberTo0Spaces(number: Double) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 0
        return numFormatter.string(for: number)!
    }
    
    private func formatNumberTo2Spaces(number: Double) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 2
        numFormatter.maximumFractionDigits = 2
        return numFormatter.string(for: number)!
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let nutrients = nutrients else { return }
    }
    
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
    
    
    @IBAction func logFood(_ sender: Any) {
        guard let record = self.dailyRecord else { return }
        
        Network.shared.createFoodLog(calories: record.calories, fat: record.fat, carbs: record.carbs, fiber: record.fiber, protein: record.protein, foodString: record.food_string, quantity: record.quantity, mealType: record.meal_type) { (_) in
            print("\(record.food_string) is logged.")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension LSLFoodDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == servingSizePickerView {
            let sizeIndex = pickerView.selectedRow(inComponent: row)
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

extension LSLFoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isTyping = true
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor(red: 0, green: 0.259, blue: 0.424, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor(red: 0, green: 0.455, blue: 0.722, alpha: 0.5).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isTyping = false
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1).cgColor
        textField.layer.cornerRadius = 4
        textField.layer.shadowOpacity = 0
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !isTyping, textField == qtyTextField {
            guard let text = qtyTextField.text, let value = Int(text) else { return }
            self.quantityInputValue = value
        }
    }
}
