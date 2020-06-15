//
//  SceneDelegate.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/10/20.
//  Copyright © 2020 Michael Stoffer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            var rootVC: UIViewController?
            
            if Network.isLoggedIn() {
                guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(identifier: "DashboardTabBar") as? UITabBarController else {
                    print("Unable to instantiate dashboard")
                    return
                }
                rootVC = vc
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
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

