//
//  SceneDelegate.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        IQKeyboardManager.shared.enable = true
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
        
        if RootStoryboard.rootStoryboard == nil {
            navigationController.viewControllers = [UIStoryboard(name: "LoginScreen", bundle: nil).instantiateInitialViewController() ?? UIViewController()]
        } else {
                        
            let rootViewController = UIStoryboard(name: RootStoryboard.rootStoryboard, bundle: nil).instantiateInitialViewController()
            navigationController.viewControllers = [rootViewController!]
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
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
