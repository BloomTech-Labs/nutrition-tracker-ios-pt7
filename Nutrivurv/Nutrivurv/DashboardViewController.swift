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

class DashboardViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet weak var streakCountLabel: UILabel!
    @IBOutlet weak var currentWeightLabel: UILabel!
    @IBOutlet weak var dailyVibeQuoteLabel: UILabel!
    @IBOutlet weak var dailyVibeAuthorLabel: UILabel!
    
    @IBOutlet weak var dailyVibeStackView: UIStackView!
    
    let userController = ProfileCreationController()
    
    
    // MARK: Custom Views
    
    lazy var dailyVibeBackgroundView: UIView = {
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
    
    
    // MARK: - View Lifecycle Methods and Update Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareForEntranceAnimations()
        
        let contentView = setUpNavBarImageView()
        self.navigationItem.titleView = contentView
        
        let dashboardNavBarAttrs = [NSAttributedString.Key.font: UIFont(name: "Muli-ExtraBold", size: 18)!]
        self.navigationController?.navigationBar.titleTextAttributes = dashboardNavBarAttrs
        
        self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        
        if UserAuthController.isLoggedIn() {
            self.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
            QuoteController.shared.getRandomQuote { (result) in
                switch result {
                case .success(let quote):
                    self.dailyVibeQuoteLabel.text = "\"\(quote.content)\""
                    self.dailyVibeAuthorLabel.text = quote.author
                    self.setUpDailyVibeBackgroundView()
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
    }
    
    // MARK: - Setup Subviews
    
    private func setUpNavBarImageView() -> UIView {
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
    
    @IBSegueAction func addActivtyRingView(_ coder: NSCoder) -> UIViewController? {
        let hostingController = UIHostingController(coder: coder, rootView: ActivityProgressView())
        hostingController?.view.backgroundColor = UIColor.clear
        
        return hostingController
    }
    
    private func setUpDailyVibeBackgroundView() {
        dailyVibeStackView.insertSubview(self.dailyVibeBackgroundView, at: 0)
        self.dailyVibeBackgroundView.pin(to: dailyVibeStackView)
    }
    
    // MARK: Update Subviews
    
    // Need to manually update shadow color when trait collections change, as cgColor is not dynamic like UIColor
    private func updateDailyVibeShaodw() {
        self.dailyVibeBackgroundView.layer.shadowColor = UIColor(named: "daily-vibe-shadow")!.cgColor
    }
    
    // Called when trait collections are made, like switching between Light <-> Dark mode to enable changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateDailyVibeShaodw()
    }
    
    
    // MARK: - Subview Animations
    
    private func prepareForEntranceAnimations() {
        self.dailyVibeStackView.alpha = 0
        self.dailyVibeStackView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    private func animateSubviewsForEntry() {
        UIView.animate(withDuration: 0.65, delay: 0.28, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.4, options: .curveEaseInOut, animations: {
            
            // Fades the daily vibe section onto screen
            self.dailyVibeStackView.alpha = 1
            
            // Scales the daily vibe section up to size
            self.dailyVibeStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let keychain = KeychainSwift()
        keychain.clear()
        FoodLogController.shared.foodLog.removeAll()
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "MainAppWelcome") as! UINavigationController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - Profile Completion Protocol Declaration & Delegate Conformance

extension DashboardViewController: CreateProfileCompletionDelegate {
    func profileWasCreated() {
//        self.loadProfile()
    }
}

protocol CreateProfileCompletionDelegate {
    func profileWasCreated()
}
