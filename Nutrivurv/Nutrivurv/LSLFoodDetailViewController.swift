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
    @IBOutlet weak var proteinPercentageLabel: UILabel!
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
    var foodItem: FoodItem? {
        didSet {
            self.updateViews()
        }
    }
    
    var servingSizes: [String] = ["Serving", "Whole", "Jumbo", "Gram", "Ounce", "Pound", "Kilogram", "Cup", "Liter"]
    var mealTypes: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qtyTextField.delegate = self

        self.servingSizePickerView.delegate = self
        self.servingSizePickerView.dataSource = self
        
        self.mealTypePickerView.delegate = self
        self.mealTypePickerView.dataSource = self
        
        self.updateViews()
                
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
        guard let foodItem = self.foodItem, isViewLoaded else { return }
        self.navigationItem.title = foodItem.food.label
        self.qtyTextField.text = "1"
        self.servingSizePickerView.selectRow((servingSizes.firstIndex(of: foodItem.measures[0].label)) ?? 0, inComponent: 0, animated: true)
        
        // Perform a search for the nutrients of the food item...
        self.searchController?.searchForNutrients(qty: 1, measure: foodItem.measures[0].uri, foodId: foodItem.food.foodId, completion: {
            guard let nutrients = self.searchController?.nutrients else { return }
            DispatchQueue.main.async {
                print("Nutrients: \(nutrients)")
                self.calorieLabel.text = "\(nutrients.calories)"
                
                self.totalFatMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.FAT.quantity))\(nutrients.totalNutrients.FAT.unit)"
                self.totalFatPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.FAT.quantity))\(nutrients.totalDaily.FAT.unit)"
                self.sodiumMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.NA.quantity))\(nutrients.totalNutrients.NA.unit)"
                self.sodiumPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.NA.quantity))\(nutrients.totalDaily.NA.unit)"
                self.totalCarbsMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.CHOCDF.quantity))\(nutrients.totalNutrients.CHOCDF.unit)"
                self.totalCarbsPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.CHOCDF.quantity))\(nutrients.totalDaily.CHOCDF.unit)"
                self.cholesterolMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.CHOLE.quantity))\(nutrients.totalNutrients.CHOLE.unit)"
                self.cholesterolPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.CHOLE.quantity))\(nutrients.totalDaily.CHOLE.unit)"
                self.sugarMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.SUGAR.quantity))\(nutrients.totalNutrients.SUGAR.unit)"
                self.proteinMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.PROCNT.quantity))\(nutrients.totalNutrients.PROCNT.unit)"
                self.proteinPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.PROCNT.quantity))\(nutrients.totalDaily.PROCNT.unit)"
                self.vitaminDMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.VITD.quantity))\(nutrients.totalNutrients.VITD.unit)"
                self.vitaminDPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.VITD.quantity))\(nutrients.totalDaily.VITD.unit)"
                self.calciumMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.CA.quantity))\(nutrients.totalNutrients.CA.unit)"
                self.calciumPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.CA.quantity))\(nutrients.totalDaily.CA.unit)"
                self.ironMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.FE.quantity))\(nutrients.totalNutrients.FE.unit)"
                self.ironPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.FE.quantity))\(nutrients.totalDaily.FE.unit)"
                self.potassiumMeasureLabel.text = "\(self.formatNumberTo2Spaces(number: nutrients.totalNutrients.K.quantity))\(nutrients.totalNutrients.K.unit)"
                self.potassiumPercentageLabel.text = "\(self.formatNumberTo0Spaces(number: nutrients.totalDaily.K.quantity))\(nutrients.totalDaily.K.unit)"
                
                guard let qty = self.qtyTextField.text, !qty.isEmpty else { return }
                
                let currentDateTime = Date()
                self.dailyRecord = DailyLog(date: "\(currentDateTime)", calories: nutrients.calories, fat: Int(nutrients.totalDaily.FAT.quantity), carbs: Int(nutrients.totalDaily.CHOCDF.quantity), fiber: Int(nutrients.totalDaily.FIBTG.quantity), protein: Int(nutrients.totalDaily.PROCNT.quantity), food_string: foodItem.food.label, quantity: Int(qty)!, meal_type: self.mealTypes[self.mealTypePickerView.selectedRow(inComponent: 0)])
            }
        })
    }

    @IBAction func logFood(_ sender: Any) {
        guard let record = self.dailyRecord else { return }
        
        Network.shared.createFoodLog(calories: record.calories, fat: record.fat, carbs: record.carbs, fiber: record.fiber, protein: record.protein, foodString: record.food_string, quantity: record.quantity, mealType: record.meal_type) { (_) in
            print("\(record.food_string) is logged.")
            self.navigationController?.popViewController(animated: true)
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

extension LSLFoodDetailViewController: UIPickerViewDelegate {
}

extension LSLFoodDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes.count
        default:
            return self.mealTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case servingSizePickerView:
            return self.servingSizes[row]
        default:
            return self.mealTypes[row]
        }
    }
}

extension LSLFoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
