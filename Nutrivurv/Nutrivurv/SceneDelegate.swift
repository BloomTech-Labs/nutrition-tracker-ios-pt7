//
//  SceneDelegate.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit
import ESTabBarController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // This code runs upon app load to determine which view to present to user based on logged in state
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            var rootVC: UIViewController?
            
            if UserAuthController.isLoggedIn() {
                guard let tabBarVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "DashboardTabBar") as? ESTabBarController else {
                    print("Unable to instantiate dashboard")
                    return
                }
                
                if let tabBar = tabBarVC.tabBar as? ESTabBar {
                    tabBar.itemCustomPositioning = .fillIncludeSeparator
                }
                
                guard let v1 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "DashboardNavController") as? UINavigationController else {
                    print("Error instatiating dashboard vc")
                    return
                }
                
                guard let v2 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "FoodSearchNavController") as? UINavigationController else {
                    print("Error instatiating food search vc")
                    return
                }
                
                let v1ContentView = ESTabBarItemContentView()
                let v2ContentView = ESTabBarItemContentView()
                
                v1.tabBarItem = ESTabBarItem.init(v1ContentView, title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"), tag: 0)
                v2.tabBarItem = ESTabBarItem.init(v2ContentView, title: nil, image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_1"), tag: 1)
                
                tabBarVC.viewControllers = [v1, v2]
                
                rootVC = tabBarVC
            } else {
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainAppWelcome") as? UINavigationController else {
                    print("Unable to instantiate main")
                    return
                }
                rootVC = vc
            }
            window.rootViewController = rootVC
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        UserDefaults.updateLoginDateAndStreak()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.updateLoginDateAndStreak()
    }
}

