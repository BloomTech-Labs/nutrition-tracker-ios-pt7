//
//  AppDelegate.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navBarAttrs = [NSAttributedString.Key.font: UIFont(name: "Catamaran-Bold", size: 16)!]
        let navBarBtnAttrs = [NSAttributedString.Key.font: UIFont(name: "Catamaran-Bold", size: 14)!]
        let tabBarAttrs = [NSAttributedString.Key.font: UIFont(name: "Catamaran-SemiBold", size: 10)!]
        
        UINavigationBar.appearance().titleTextAttributes = navBarAttrs
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarBtnAttrs, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(tabBarAttrs, for: .normal)
        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self, UISearchBar.self]).font = UIFont(name: "Catamaran-SemiBold", size: 16)!
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

