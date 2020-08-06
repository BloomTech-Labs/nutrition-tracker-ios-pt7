//
//  SceneDelegate.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // This code runs upon app load to determine which view to present to user based on logged in state
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            var rootVC: UIViewController?
            
            if UserAuthController.isLoggedIn() {
                
                // Custom class that returns a tab bar to be used throughout app
                // This tab bar is the primary view controller for the Dashboard.storyboard
                let tabBarVC = CustomTabBar.getTabBar()
                
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

