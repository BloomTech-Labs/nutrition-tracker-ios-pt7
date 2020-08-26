//
//  FoodLogTableViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class FoodLogTableViewController: UITableViewController {
    
    var foodLog: FoodLog?
    
    let foodSearchController = FoodSearchController()
    
    // A default message label displayed as table view background view when users food log is empty for selected date
    var noFoodLoggedLabel: UILabel?
    
    var selectedDateAsString: String? {
        didSet {
            self.updateFoodLog()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFoodLog), name: .newFoodItemLogged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedDateFromController(_:)), name: .selectedDateChanged, object: nil)
        self.setDateForLogEntries()
    }
    
    @objc func receivedDateFromController(_ notification: Notification) {
        if let date = notification.object as? Date {
            setDateForLogEntries(date)
        }
    }
    
    @objc func reloadFoodLogTableView() {
        if foodLogIsEmpty() {
            noFoodLoggedMessage(message: "You haven't logged any foods yet,\n tap the grocery bag icon below to get started!")
        } else {
            tableView.backgroundView = .none
            tableView.separatorStyle = .singleLine
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFoodLogTableView()
    }
    
    private func setDateForLogEntries(_ date: Date = Date()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.selectedDateAsString = dateFormatter.string(from: date)
    }
    
    private func noFoodLoggedMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "nutrivurv-blue-new")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "QuattrocentoSans-Italic", size: 16)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    // MARK: - Custom View Setup
    
    private func getTableviewHeaderMacrosView(using model: DailyMacros) -> UIView {
        let view = UIView()
        
        let hostingController = UIHostingController(rootView: TableViewSectionHeader(dailyMacrosModel: model))
        hostingController.view.backgroundColor = UIColor.clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hostingController.view)
        hostingController.view.pinWithNoPadding(to: view)
        
        return view
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MealType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let foodLog = foodLog else { return 0 }
        
        switch section {
        case 0:
            if let breakfast = foodLog.breakfast {
                return breakfast.count
            }
        case 1:
            if let lunch = foodLog.lunch {
                return lunch.count
            }
        case 2:
            if let dinner = foodLog.dinner {
                return dinner.count
            }
        case 3:
            if let snack = foodLog.snack {
                return snack.count
            }
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let foodLog = foodLog else { return nil }
        
        let label = MealTypeHeaderLabel()
        var macrosByMealModel: DailyMacros?
        
        switch section {
            case 0:
                if foodLog.breakfast != nil {
                    label.text = "breakfast"
                    macrosByMealModel = FoodLogController.shared.breakfastMacrosModel
                }
            case 1:
                if foodLog.lunch != nil {
                    label.text = "lunch"
                    macrosByMealModel = FoodLogController.shared.lunchMacrosModel
                }
            case 2:
                if foodLog.dinner != nil {
                    label.text = "dinner"
                    macrosByMealModel = FoodLogController.shared.dinnerMacrosModel
                }
            case 3:
                if foodLog.snack != nil {
                    label.text = "snacks"
                    macrosByMealModel = FoodLogController.shared.snacksMacrosModel
                }
            default:
                label.text = nil
        }
        
        guard label.text != nil, let macrosModel = macrosByMealModel else {
            return nil
        }
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center

        let macrosHeaderView = getTableviewHeaderMacrosView(using: macrosModel)
        macrosHeaderView.translatesAutoresizingMaskIntoConstraints = false

        horizontalStackView.addArrangedSubview(macrosHeaderView)
        
        let mealTypeContainerView = UIView()

        mealTypeContainerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: mealTypeContainerView.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: mealTypeContainerView.trailingAnchor, constant: -12).isActive = true

        mealTypeContainerView.layer.shadowColor = UIColor.black.cgColor
        mealTypeContainerView.layer.shadowOpacity = 0.225
        mealTypeContainerView.layer.shadowRadius = 8.0
        mealTypeContainerView.layer.shadowOffset = CGSize(width: 1.5, height: 2.5)
        
        horizontalStackView.addArrangedSubview(mealTypeContainerView)
        
        return horizontalStackView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let foodLog = foodLog else { return 0 }
        var headerSize: CGFloat = 0
        
        switch section {
            case 0:
                if foodLog.breakfast != nil {
                    headerSize = 68
                }
            case 1:
                if foodLog.lunch != nil {
                    headerSize = 68
                }
            case 2:
                if foodLog.dinner != nil {
                    headerSize = 68
                }
            case 3:
                if foodLog.snack != nil {
                    headerSize = 68
                }
            default:
                return 0
        }
        
        return headerSize
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodLogCell", for: indexPath)
        
        guard let foodLog = foodLog else { return cell }
        
        var meal: FoodLogEntry?
        
        switch indexPath.section {
        case 0:
            if let breakfast = foodLog.breakfast {
                meal = breakfast[indexPath.row]
            }
        case 1:
            if let lunch = foodLog.lunch {
                meal = lunch[indexPath.row]
            }
        case 2:
            if let dinner = foodLog.dinner {
                meal = dinner[indexPath.row]
            }
        case 3:
            if let snacks = foodLog.snack {
                meal = snacks[indexPath.row]
            }
        default:
            break
        }
        
        cell.textLabel?.text = meal?.foodName.capitalized
        cell.detailTextLabel?.text = meal?.mealType.capitalized
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let foodLog = foodLog, !foodLogIsEmpty() else { return }
        
        var foodEntry: FoodLogEntry?
        
        switch indexPath.section {
        case 0:
            if let allBreakfast = foodLog.breakfast {
                foodEntry = allBreakfast[indexPath.row]
            }
        case 1:
            if let allLunch = foodLog.lunch {
                foodEntry = allLunch[indexPath.row]
            }
        case 2:
            if let allDinner = foodLog.dinner {
                foodEntry = allDinner[indexPath.row]
            }
        case 3:
            if let allSnacks = foodLog.snack {
                foodEntry = allSnacks[indexPath.row]
            }
        default:
            foodEntry = nil
        }
        
        guard let entry = foodEntry else { return }
        
        if let detailvc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "SwiftUIFoodDetail") as? SwiftUIDetailViewController {
            detailvc.foodLogEntry = entry
            detailvc.searchController = foodSearchController
            
            detailvc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailvc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let foodLog = foodLog else { return }
        var entry: FoodLogEntry?
        
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                if let allBreakfast = foodLog.breakfast {
                    entry = allBreakfast[indexPath.row]
                    self.foodLog?.breakfast?.remove(at: indexPath.row)
                }
            case 1:
                if let allLunch = foodLog.lunch {
                    entry = allLunch[indexPath.row]
                    self.foodLog?.lunch?.remove(at: indexPath.row)
                }
            case 2:
                if let allDinner = foodLog.dinner {
                    entry = allDinner[indexPath.row]
                    self.foodLog?.dinner?.remove(at: indexPath.row)
                }
            case 3:
                if let allSnacks = foodLog.snack {
                    entry = allSnacks[indexPath.row]
                    self.foodLog?.snack?.remove(at: indexPath.row)
                }
            default:
                entry = nil
            }
            
            if let entry = entry {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                FoodLogController.shared.deleteFoodLogEntry(entry: entry) { (result) in
                    if result == .success(true) {
                        self.updateFoodLog()
                    }
                }
            }
        }
    }
    
    // MARK: - Alert Controllers
    
    private func generalNetworkingErrorAlert() {
        let alert = UIAlertController.createAlert(title: "Food Log Not Available", message: "We were unable to download your food log. Please check your internet connection and try again.", style: .alert)
        self.present(alert, animated: true)
    }
    
    @objc private func updateFoodLog() {
        guard let date = selectedDateAsString else { return }
        
        FoodLogController.shared.getFoodLogEntriesForDate(date: date) { (result) in
            switch result {
            case .success(let foodLog):
                self.foodLog = foodLog
                self.tableView.reloadData()
                self.reloadFoodLogTableView()
                
                if self.foodLogIsEmpty() {
                    FoodLogController.shared.totalDailyMacrosModel.resetMacros()
                }
            case .failure(let error):
                if error == .badAuth || error == .noAuth {
                    self.reauthorizeUser()
                } else if error == .otherError {
                    self.generalNetworkingErrorAlert()
                }
                return
            }
        }
    }
    
    private func foodLogIsEmpty() -> Bool {
        guard let foodLog = foodLog else { return true }
        return foodLog.breakfast == nil && foodLog.lunch == nil && foodLog.dinner == nil && foodLog.snack == nil && foodLog.water == nil
    }
    
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
                        self.updateFoodLog()
                    } else {
                        print("Error reauthorizing user")
                        return
                    }
                }
            }
        }
        
        alertController.addAction(signOut)
        alertController.addAction(login)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func logoutOfApp() {
        UserController.keychain.clear()
        FoodLogController.shared.foodLog = FoodLog()
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "dailyLoginStreak")
        userDefaults.removeObject(forKey: "previousLoginDate")
        userDefaults.removeObject(forKey: "weightUnitPreference")
        userDefaults.removeObject(forKey: "heightUnitPreference")
        
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "MainAppWelcome") as! UINavigationController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        self.present(viewController, animated: true, completion: nil)
    }
}

extension FoodLogTableViewController: EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int) {
//        foodLogController.foodLog[index] = entry
    }
}


protocol EditFoodEntryDelegate {
    func update(foodLog entry: FoodLogEntry, at index: Int)
}
