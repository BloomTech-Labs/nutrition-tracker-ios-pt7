//
//  DashboardViewController.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import KeychainSwift
import SwiftUI
import Combine
import HealthKit

class DashboardViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet weak var streakCountLabel: UILabel!
    @IBOutlet weak var streakUnitLabel: UILabel!
    
    @IBOutlet weak var currentWeightLabel: UILabel!
    @IBOutlet weak var dailyVibeQuoteLabel: UILabel!
    @IBOutlet weak var dailyVibeAuthorLabel: UILabel!
    
    // Primary Views
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var streakStackView: UIStackView!
    
    // Subviews
    @IBOutlet weak var dailyVibeStackView: UIStackView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var previousDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    
    @IBOutlet weak var foodLogTableView: FadedFoodLogBackgroundView!
    
    @IBOutlet weak var ringsAndMacrosContainerView: UIView!
    var ringsAndMacrosHostingController: UIViewController!
    
    let userController = ProfileCreationController()
    
    // Used to display the alert to prompt user for HealthKit access only once
    private var displayedHKAccessAlert = false
    
    // MARK: Custom Views
    
    lazy var dailyVibeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "daily-vibe")
        view.layer.cornerRadius = 14.0
        view.layer.shadowColor = UIColor(named: "daily-vibe-shadow")?.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 1.3, height: 1.3)
        view.layer.shadowRadius = 9.0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var selectedDate: Date = Date() {
        didSet {
            FoodLogController.shared.setNewSelectedDate(selectedDate)
            if Calendar.current.isDateInToday(selectedDate) {
                self.nextDateButton.isEnabled = false
                self.nextDateButton.setTitleColor(UIColor(named: "disabled-button-text"), for: .normal)
            } else {
                self.nextDateButton.isEnabled = true
                self.nextDateButton.setTitleColor(UIColor(named: "food-log-label-text"), for: .normal)
            }
            self.setSelectedDateLabelText(selectedDate)
        }
    }
    
    // MARK: - View Lifecycle Methods and Update Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLoginStreakLabel()
        addActivityRingsProgressView()
        
        getCurrentWeight()
        
        prepareForEntranceAnimations()
        animatePrimaryViewsForEntry()
        
        setupDateView()
        self.nextDateButton.isEnabled = false
        self.nextDateButton.setTitleColor(UIColor(named: "disabled-button-text"), for: .normal)
        self.setSelectedDateLabelText()
        
        let contentView = setupNavBarImageView()
        self.navigationItem.titleView = contentView
        
        self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        
        if UserAuthController.isLoggedIn() {
            self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
            QuoteController.shared.getRandomQuote { (result) in
                switch result {
                case .success(let quote):
                    self.dailyVibeQuoteLabel.text = "\"\(quote.content)\""
                    self.dailyVibeAuthorLabel.text = quote.author
                    self.setupDailyVibeBackgroundView()
                    self.animateSubviewsForEntry()
                    
                default:
                    break
                }
            }
        } else {
            self.logoutButtonTapped(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.updateLoginStreakLabel()
    }
    
    
    // MARK: - Setup Subviews
    
    private func setupNavBarImageView() -> UIView {
        let logoImage = UIImage(named: "dashboard-nav-logo")
        let logoImageView = UIImageView(image: logoImage)
        var frame = logoImageView.frame
        frame.size.width = 85
        frame.size.height = 46
        logoImageView.frame = frame
        logoImageView.contentMode = .scaleAspectFit

        let contentView = UIView()
        contentView.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        return contentView
    }
    
    private func addActivityRingsProgressView() {
        let hostingController = UIHostingController(rootView: RingsAndMacrosView(dailyMacrosModel: FoodLogController.shared.totalDailyMacrosModel))
        hostingController.view.backgroundColor = UIColor.clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.ringsAndMacrosHostingController = hostingController
        self.ringsAndMacrosContainerView.addSubview(hostingController.view)
        
        hostingController.view.pinWithNoPadding(to: ringsAndMacrosContainerView)
    }
    
    private func updateLoginStreakLabel() {
        let streak = UserDefaults.getLoginStreak()
        if streak == 1 {
            streakUnitLabel.text = "day"
        } else {
            streakUnitLabel.text = "days"
        }
        streakCountLabel.text = "\(streak)"
    }
    
    private func setupDailyVibeBackgroundView() {
        dailyVibeStackView.insertSubview(self.dailyVibeBackgroundView, at: 0)
        self.dailyVibeBackgroundView.pin(to: dailyVibeStackView)
    }
    
    private func setupDateView() {
        let height: CGFloat = 48
        dateView.layer.cornerRadius = height / 2
        dateView.layer.cornerCurve = .continuous
        
        dateView.layer.shadowColor = UIColor(named: "daily-vibe-shadow")?.cgColor
        dateView.layer.shadowOpacity = 1.0
        dateView.layer.shadowOffset = CGSize(width: 1.3, height: 1.3)
        dateView.layer.shadowRadius = 10.0
       
        dateView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Update Subviews
    
    // Need to manually update daily vibe shadow color when trait collections change, as cgColor is not dynamic like UIColor
    private func updateDailyVibeShadow() {
        self.dailyVibeBackgroundView.layer.shadowColor = UIColor(named: "daily-vibe-shadow")?.cgColor
        self.dateView.layer.shadowColor = UIColor(named: "daily-vibe-shadow")?.cgColor
    }
    
    // Called when trait collections are made, like switching between Light <-> Dark mode to enable changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateDailyVibeShadow()
    }
    
    private func setSelectedDateLabelText(_ date: Date = Date()) {
        // TODO: Allow user to visit previous calendar dates to get log for that date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        self.selectedDateLabel.text = dateFormatter.string(from: date).lowercased()
        setDateDescriptionLabelText()
    }
    
    private func setDateDescriptionLabelText() {
        var descriptionText = ""
        
        if Calendar.current.isDateInToday(selectedDate) {
            descriptionText = "today"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            descriptionText = "yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            descriptionText = dateFormatter.string(from: selectedDate).lowercased()
        }
        
        self.dateDescriptionLabel.text = descriptionText
    }
    
    
    // MARK: - Subview Animations
    
    private func prepareForEntranceAnimations() {
        // Primary Views (Weight, Daily Intake, Streak)
        self.weightStackView.translatesAutoresizingMaskIntoConstraints = false
        self.weightStackView.alpha = 0
        self.weightStackView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        self.streakStackView.translatesAutoresizingMaskIntoConstraints = false
        self.streakStackView.alpha = 0
        self.streakStackView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        // Sub Views
        self.dailyVibeStackView.alpha = 0
        self.dailyVibeStackView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        self.dateView.alpha = 0
        self.dateView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        self.foodLogTableView.translatesAutoresizingMaskIntoConstraints = false
        self.foodLogTableView.alpha = 0
        self.foodLogTableView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    private func animatePrimaryViewsForEntry() {
        UIView.animate(withDuration: 0.45, delay: 0.1, usingSpringWithDamping: 0.82, initialSpringVelocity: 1.4, options: .curveEaseInOut, animations: {
            self.weightStackView.alpha = 1
            self.weightStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.streakStackView.alpha = 1
            self.streakStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func animateSubviewsForEntry() {
        UIView.animate(withDuration: 0.45, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.4, options: .curveEaseInOut, animations: {
            // Fades the component onto screen
            self.dailyVibeStackView.alpha = 1
            
            // Scales component up to size
            self.dailyVibeStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        UIView.animate(withDuration: 0.45, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.4, options: .curveEaseInOut, animations: {
            self.dateView.alpha = 1
            self.dateView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.4, options: .curveEaseInOut, animations: {
            self.foodLogTableView.alpha = 1
            self.foodLogTableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        // TODO: Fix bug where logout button font changes when tapping
        
        let keychain = KeychainSwift()
        
        // Reset all necessary properties
        keychain.clear()
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
    
    @IBAction func previousDateButtonTapped(_ sender: Any) {
        let currentDate = self.selectedDate
        let newDate = currentDate.advanced(by: -86_400)
        self.selectedDate = newDate
    }
    
    @IBAction func nextDateButtonTapped(_ sender: Any) {
        if Calendar.current.isDateInToday(selectedDate) {
            return
        }
        
        let currentDate = self.selectedDate
        let newDate = currentDate.advanced(by: 86_400)
        self.selectedDate = newDate
    }
    
    
    // MARK: - HealthKit Data Functionality
    
    private func getCurrentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("The weight sample type is not avaiable from HealtKit")
            return
        }
        
        HealthKitController.getMostRecentSample(for: weightSampleType) { (weightSample, error) in
            if let error = error {
                self.promptForHKAccessToWeight()
                print("Error getting most recent weight sample form HealthKit: \(error)")
                return
            }
            
            guard let weightSample = weightSample else {
                self.promptForHKAccessToWeight()
                print("Failed to get weight sample data")
                return
            }
            
            let weightInPounds = weightSample.quantity.doubleValue(for: HKUnit.pound())
            self.currentWeightLabel.text = String(format: "%.1f", weightInPounds)
        }
    }
    
    private func promptForHKAccessToWeight() {
        if displayedHKAccessAlert == true {
            return
        }
        
        let alertController = UIAlertController(title: "Health Access", message: "We need permission to access your health data to provide a more personalized experience. If you have previosuly declined access, open the privacy settings within your settings app to allow access.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.requestHealthKitAuthorization { (result) in
                self.displayedHKAccessAlert = true
                
                if result == true {
                    self.getCurrentWeight()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func requestHealthKitAuthorization(completion: @escaping (Bool) -> Void) {
        HealthKitController.authorizeHealthKit { (authorized, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
