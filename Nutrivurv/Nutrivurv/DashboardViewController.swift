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
    
    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    @IBOutlet weak var dailyVibeQuoteLabel: UILabel!
    @IBOutlet weak var dailyVibeAuthorLabel: UILabel!
    
    let userController = ProfileCreationController()
    
    // MARK: - View Lifecycle Methods and Update Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let hostingController = UIHostingController(coder: coder, rootView: ActivityRingsView())
        hostingController?.view.backgroundColor = UIColor.clear
        
        return hostingController
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
