//
//  CustomTabBar.swift
//  Nutrivurv
//
//  Created by Dillon on 8/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class CustomTabBar {
    static func getTabBar() -> TabBarController? {
        
        let tabBarVC = TabBarController()
        
        if let tabBar = tabBarVC.tabBar as? TabBar {
            tabBar.itemCustomPositioning = .fillExcludeSeparator
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
        }
        
        guard let v1 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "DashboardNavController") as? UINavigationController else {
            print("Error instatiating dashboard vc")
            return nil
        }
        
        guard let v2 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "FoodSearchNavController") as? UINavigationController else {
            print("Error instatiating food search vc")
            return nil
        }
        
        guard let v3 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "HealthDashboard") as? HealthDashboardViewController else {
            print("Error instatiating health dashboard")
            return nil
        }
        
        let v1ContentView = IrregularityBasicContentView()
        let v2ContentView = IrregularityBasicContentView()
        let v3ContentView = IrregularityBasicContentView()
        
        
        v1.tabBarItem = TabBarItem.init(v1ContentView, title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"), tag: 0)
        v2.tabBarItem = TabBarItem.init(v2ContentView, title: nil, image: UIImage(named: "grocery"), selectedImage: UIImage(named: "grocery_1"), tag: 1)
        v3.tabBarItem = TabBarItem.init(v3ContentView, title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"), tag: 2)
        
        tabBarVC.viewControllers = [v1, v2, v3]
        
        return tabBarVC
    }
}
