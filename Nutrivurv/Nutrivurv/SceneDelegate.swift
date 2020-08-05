//
//  SceneDelegate.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // This code runs upon app load to determine which view to present to user based on logged in state
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            var rootVC: UIViewController?
            
            if UserAuthController.isLoggedIn() {
                guard let tabBarVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "DashboardTabBar") as? TabBarController else {
                    print("Unable to instantiate dashboard")
                    return
                }
                
                tabBarVC.delegate = self
                
                tabBarVC.tabBar.shadowImage = UIImage(named: "tb-transparent")
                tabBarVC.tabBar.backgroundImage = UIImage(named: "tb-bg-dark")
                tabBarVC.shouldHijackHandler = {
                    tabbarController, viewController, index in
                    if index == 2 {
                        return true
                    }
                    return false
                }
                
                
                if let tabBar = tabBarVC.tabBar as? TabBar {
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
                
                let v3 = UIViewController()
                
                let v1ContentView = IrregularityBasicContentView()
                let v2ContentView = IrregularityContentView()
                let v3ContentView = IrregularityBasicContentView()
                
                
                v1.tabBarItem = TabBarItem.init(v1ContentView, title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"), tag: 0)
                v2.tabBarItem = TabBarItem.init(v2ContentView, title: nil, image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_1"), tag: 1)
                v3.tabBarItem = TabBarItem.init(v3ContentView, title: nil, image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"), tag: 2)
                
                tabBarVC.viewControllers = [v1, v2, v3]
                
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

