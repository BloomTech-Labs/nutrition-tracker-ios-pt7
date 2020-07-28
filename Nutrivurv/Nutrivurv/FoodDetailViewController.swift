//
//  FoodDetailViewController.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/15/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    
    @IBOutlet weak var healthLabelsScrollView: FadedHorizontalScrollView!
    @IBOutlet weak var healthLabelsStackView: UIStackView!
    
    @IBOutlet weak var healthCautionsScrollView: FadedHorizontalScrollView!
    @IBOutlet weak var healthCautionsStackView: UIStackView!
    @IBOutlet weak var containsWarningLabel: UILabel!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var userInputStackView: UIStackView!
    
    @IBOutlet weak var nutritionalContentScrollView: FadedVerticalScrollView!
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
    
    @IBOutlet weak var addFoodButton: UIButton!
    
    // MARK: - Properties & Model Controllers
    
    var searchController: FoodSearchController?
    
    private var searchDelayTimer = Timer()
    private var qtyTypeTimer = Timer()
    
    var foodItem: FoodItem? {
        didSet {
            if let imageURL = foodItem?.food.image {
                self.getFoodImage(urlString: imageURL)
            }
            self.getFoodDetails()
            for measure in foodItem!.measures {
                let typeOfMeasure = measure.label
                self.servingSizes.append(typeOfMeasure)
            }
        }
    }
    
    var foodLogEntry: FoodLogEntry?
    
    var nutrients: Nutrients? {
        didSet {
            // Since we declared the completion on the main queue in search controller, no need to do it here
            self.updateViews()
        }
    }
    
    var selectedServingSize: Int? {
        didSet {
            self.getFoodDetails()
        }
    }
    
    var quantityInputValue: Double? {
        didSet {
            self.getFoodDetails()
        }
    }
    
    var calories: Int?
    var carbs: String?
    var protein: String?
    var fat: String?
    
    var servingSizes: [String] = []
    var mealTypes: [String] = FoodLogController.shared.defaultMealTypes
    
    // These variables help setup views and food logging functionality to enable editing an entry vs. logging a new one
    var fromLog: Bool = false
    var selectedFoodEntryIndex: Int?
    var delegate: EditFoodEntryDelegate?
    
    
    // MARK: Custom View Variables
    
    lazy var userInputBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "daily-vibe")
        view.layer.cornerRadius = 14.0
        view.layer.shadowColor = UIColor(named: "daily-vibe-shadow")!.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 1.3, height: 1.3)
        view.layer.shadowRadius = 9.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodImageView.layer.cornerRadius = 8.0

        if let foodItem = foodItem {
            // If coming from search to explore/log a new food
            self.setUpViewForNewEntry(with: foodItem)
        } else {
            // If coming from existing food log, with data provided by backend
            self.getFoodDetails()
        }
        
        self.qtyTextField.delegate = self
        
        self.servingSizePickerView.delegate = self
        self.servingSizePickerView.dataSource = self
        
        self.mealTypePickerView.delegate = self
        self.mealTypePickerView.dataSource = self
        
        self.setUpUserInputBackgroundView()
        self.qtyTextField.font = UIFont(name: "QuattrocentoSans-Bold", size: 14)
        self.addFoodButton.layer.cornerRadius = 6.0
        
        if fromLog {
            addFoodButton.setTitle("Edit Entry", for: .normal)
            qtyTextField.isEnabled = false
            servingSizePickerView.isUserInteractionEnabled = false
            mealTypePickerView.isUserInteractionEnabled = false
        } else {
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
            selectedServingSize = 0
            quantityInputValue = 1.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Custom Views & View Setup
    
    private func setUpViewForNewEntry(with foodItem: FoodItem) {
        self.foodNameLabel.text = foodItem.food.label.capitalized
        self.foodCategoryLabel.text = foodItem.food.category.capitalized
        
        if let servingSizeIndex = selectedServingSize {
            self.servingSizePickerView.selectRow(servingSizeIndex, inComponent: 0, animated: true)
            self.selectedServingSize = servingSizeIndex
        }
        
        self.qtyTextField.text = "1.0"
        
        self.mealTypePickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    private func updateViews() {
        
        guard let nutrients = nutrients else { return }
        
        let calories = nutrients.calories
        self.calories = calories
        
        let totalNutrients = nutrients.totalNutrients
        let dailyPercentNutrients = nutrients.totalDaily
        
        let fat = totalNutrients.FAT?.quantity ?? 0
        let fatUnit = totalNutrients.FAT?.unit ?? ""
        let fatPct = dailyPercentNutrients.FAT?.quantity ?? 0
        self.fat = String(format: "%.2f", fat)
        
        let sodium = totalNutrients.NA?.quantity ?? 0
        let sodiumUnit = totalNutrients.NA?.unit ?? ""
        let sodiumPct = dailyPercentNutrients.NA?.quantity ?? 0
        
        let carbs = totalNutrients.CHOCDF?.quantity ?? 0
        let carbsUnit = totalNutrients.CHOCDF?.unit ?? ""
        let carbsPct = dailyPercentNutrients.CHOCDF?.quantity ?? 0
        self.carbs = String(format: "%.2f", carbs)
        
        let chole = totalNutrients.CHOLE?.quantity ?? 0
        let choleUnit = totalNutrients.CHOLE?.unit ?? ""
        let cholePct = dailyPercentNutrients.CHOLE?.quantity ?? 0
        
        let sugar = totalNutrients.SUGAR?.quantity ?? 0
        let sugarUnit = totalNutrients.SUGAR?.unit ?? ""
        
        let protein = totalNutrients.PROCNT?.quantity ?? 0
        let proteinUnit = totalNutrients.PROCNT?.unit ?? ""
        self.protein = String(format: "%.2f", protein)
        
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
        
        addHealthAndWarningLabelsIfNeeded()
    }
    
    private func addHealthAndWarningLabelsIfNeeded() {
        // Ensures that label duplicates are not added each time the user changes quantity
        guard let nutrients = nutrients, healthLabelsStackView.subviews.count == 0, healthCautionsStackView.subviews.count == 0 else {
            return
        }
        
        // Setup for health labels badges
        for item in nutrients.healthLabels {
            let label = getGreenLabelFor(item)
            healthLabelsStackView.addArrangedSubview(label)
        }
        
        // Setup for food item's warning badges
        for item in nutrients.cautions {
            let label = getYellowLabelFor(item)
            healthCautionsStackView.addArrangedSubview(label)
        }
        
        if !healthCautionsStackView.subviews.isEmpty {
            containsWarningLabel.isHidden = false
        }
    }
    
    private func getGreenLabelFor(_ string: String) -> NutritionLabel {
        let color = UIColor(named: "nutrivurv-green-2")!
        let label = setupHealthAndWarningLabels(string, color: color)
        
        return label
    }
    
    private func getYellowLabelFor(_ string: String) -> NutritionLabel {
        let color = UIColor(named: "nutrivurv-orange")!
        let label = setupHealthAndWarningLabels(string, color: color)
        
        return label
    }
    
    private func setupHealthAndWarningLabels(_ string: String, color: UIColor) -> NutritionLabel {
        let title = string.replacingOccurrences(of: "_", with: " ").capitalized
        let label = NutritionLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        if title == "Fodmap" {
            label.text = "FODMAP"
        } else {
            label.text = title
        }
        label.textAlignment = .center
        label.backgroundColor = color
        label.layer.cornerRadius = 6
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "QuattrocentoSans-Bold", size: 12)
        label.textColor = .white
        
        return label
    }
    
    private func setUpUserInputBackgroundView() {
        self.userInputStackView.insertSubview(self.userInputBackgroundView, at: 0)
        self.userInputBackgroundView.pin(to: userInputStackView)
    }
    
    
    // MARK: - Update Subviews
    
    // Need to manually update user input shadow color when trait collections change, as cgColor is not dynamic like UIColor
    private func updateUserInputViewShadow() {
        self.userInputBackgroundView.layer.shadowColor = UIColor(named: "daily-vibe-shadow")!.cgColor
    }
    
    // Called when trait collections are made, like switching between Light <-> Dark mode to enable changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUserInputViewShadow()
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
    
    private func updateQtyValue(qty: Double) {
        if self.quantityInputValue != qty {
            self.quantityInputValue = qty
        }
    }
    
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createAndDisplayAlertAndPopToRoot(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func presentEditAlert() {
        createAndDisplayAlertController(title: "Need to make changes?", message: "Tap the edit button below to update and save this food entry.")
    }
    
    @objc func qtyTypeInvalid() {
        qtyTypeTimer.invalidate()
        createAndDisplayAlertController(title: "Please enter a valid number", message: "You must enter the quantity as a number in order to get food details.")
    }
    
    // MARK: - Get Food Details
    
    private func getFoodDetails() {
        if let foodItem = foodItem {
            
            guard let servingSize = selectedServingSize, let quantity = quantityInputValue else {
                return
            }
            
            let measureURI = foodItem.measures[servingSize].uri
            let foodId = foodItem.food.foodId
            
            self.searchController?.searchForNutrients(qty: quantity, measureURI: measureURI, foodId: foodId) { (nutrients) in
                guard let nutrients = nutrients else { return }
                self.nutrients = nutrients
            }
            
        } else if let foodLogEntry = foodLogEntry {
            let measureURI = foodLogEntry.measurementURI
            let quantity = foodLogEntry.quantity
            let edamamFoodId = foodLogEntry.foodId
            
            self.searchController?.searchForNutrients(qty: quantity, measureURI: measureURI, foodId: edamamFoodId) { (nutrients) in
                self.nutrients = nutrients
            }
        }
    }
    
    @objc func delayedSearch() {
        guard let searchText = searchDelayTimer.userInfo as? String, !searchText.isEmpty else {
            return
        }
        
        self.searchDelayTimer.invalidate()
        
        guard let qty = Double(searchText) else {
            // Provides a secondary timer to allow user extra time to change input to a valid number, prevents multiple repeated alerts
            self.qtyTypeTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.qtyTypeInvalid), userInfo: nil, repeats: false)
            return
        }
        updateQtyValue(qty: qty)
    }
    
    private func getFoodImage(urlString: String) {
        self.searchController?.getFoodImage(urlString: urlString) { (data) in
            guard let data = data else {
                print("Error getting food item image")
                return
            }
            
            if let image = UIImage(data: data) {
                self.foodImageView.image = image
            }
        }
    }
    
    
    // MARK: - IBActions & Food Logging
    
    @IBAction func logFood(_ sender: Any) {
        if addFoodButton.titleLabel?.text == "Edit Entry" {
            qtyTextField.isEnabled = true
            servingSizePickerView.isUserInteractionEnabled = true
            mealTypePickerView.isUserInteractionEnabled = true
            addFoodButton.setTitle("Save Entry", for: .normal)
            addFoodButton.backgroundColor = UIColor(named: "nutrivurv-green-2")
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
            return
        }
        
        guard let foodItem = foodItem else {
            return
        }
        
        // Prepare properties for initialzing a food entry
        let date = Date()
        
        let selectedMealTypeIndex = mealTypePickerView.selectedRow(inComponent: 0)
        let mealType = self.mealTypes[selectedMealTypeIndex]
        
        let edamamID = foodItem.food.foodId
        
        let selectedServingSizeIndex = servingSizePickerView.selectedRow(inComponent: 0)
        let measureURI = foodItem.measures[selectedServingSizeIndex].uri
        
        let measurementName = self.servingSizes[selectedServingSizeIndex]
        
        let foodName = foodItem.food.label
        
        guard let quantity = quantityInputValue else { return }
        guard quantity > 0.0 else {
            createAndDisplayAlertController(title: "Select a Quantity", message: "Please input a quantity greater than 0 for your meal.")
            return
        }
        
        guard let calories = self.calories else { return }
        
        guard let fatCount = self.fat, let carbsCount = self.carbs, let proteinCount = self.protein else { return }
        
        let entry = FoodLogEntry(date: date, mealType: mealType, foodId: edamamID, measurementURI: measureURI, measurementName: measurementName, foodName: foodName, quantity: quantity, calories: calories, fat: fatCount, carbs: carbsCount, protein: proteinCount)
        
        FoodLogController.shared.createFoodLogEntry(entry: entry)
        
        if addFoodButton.titleLabel?.text == "Save Entry" {
            guard let index = selectedFoodEntryIndex else {
                print("Error getting index for food entry")
                return
            }
            createAndDisplayAlertAndPopToRoot(title: "Entry Updated!", message: "You just updated this food entry! See all of your logged meals for the day from your main dashboard.")
            delegate?.update(foodLog: entry, at: index)
        } else {
            
            // TODO: Change these macros values - possibly use environment variable with Combine?
            let caloriesFloat = CGFloat(integerLiteral: calories)
            FoodLogController.shared.caloriesCount += caloriesFloat
            FoodLogController.shared.caloriesPct += (caloriesFloat / 2775) * 100
            
            guard let carbs = self.carbs, let carbsNumber = NumberFormatter().number(from: carbs) else { return }
            let carbsFloat = CGFloat(truncating: carbsNumber)
            FoodLogController.shared.carbsCount += carbsFloat
            FoodLogController.shared.carbsPct += (carbsFloat / 40) * 100
            
            guard let protein = self.protein, let proteinNumber = NumberFormatter().number(from: protein) else { return }
            let proteinFloat = CGFloat(truncating: proteinNumber)
            FoodLogController.shared.proteinCount += proteinFloat
            FoodLogController.shared.proteinPct += (proteinFloat / 170) * 100
            
            guard let fat = self.fat, let fatNumber = NumberFormatter().number(from: fat) else { return }
            let fatFloat = CGFloat(truncating: fatNumber)
            FoodLogController.shared.fatCount += fatFloat
            FoodLogController.shared.fatPct += (fatFloat / 215) * 100
            
            
            FoodLogController.shared.foodLog.append(entry)
            createAndDisplayAlertAndPopToRoot(title: "Food Added!", message: "You just logged this item! See all of your logged meals for the day from your main dashboard.")
        }
    }
    
    @IBAction func qtyTextFieldValueChanged(_ sender: UITextField) {
        self.qtyTypeTimer.invalidate()
        self.searchDelayTimer.invalidate()
        guard let text = sender.text, !text.isEmpty else {
            return
        }
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.delayedSearch), userInfo: text, repeats: false)
    }
}


// MARK: - Picker View Delegate & Data Source

extension FoodDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == servingSizePickerView {
            let sizeIndex = pickerView.selectedRow(inComponent: 0)
            self.selectedServingSize = sizeIndex
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let font = UIFont(name: "QuattrocentoSans-Bold", size: 16)!
        
        switch pickerView {
        case servingSizePickerView:
            let title = self.servingSizes[row]
            let label = UILabel()
            label.styleForPickerView(title: title, font: font)
            return label
        default:
            let title = self.mealTypes[row]
            let label = UILabel()
            label.styleForPickerView(title: title, font: font)
            return label
        }
    }
}

extension FoodDetailViewController: UIPickerViewDataSource {
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
}


// MARK: - Text Field Delegate Methods

extension FoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, let qty = Double(text) {
            updateQtyValue(qty: qty)
            textField.text = String(qty)
        } else {
            if let quantity = quantityInputValue {
                textField.text = String(quantity)
            }
        }
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
        textField.layer.borderWidth = 0.0
        textField.layer.shadowOpacity = 0
    }
}


// MARK: - UILabel Extension For Styling UIPickerView

extension UILabel {
    func styleForPickerView(title: String, font: UIFont) {
        self.text = title
        self.font = font
        self.textColor = UIColor(named: "nutrivurv-blue")
        self.textAlignment = .center
    }
}
