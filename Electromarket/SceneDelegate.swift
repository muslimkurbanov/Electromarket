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

    var testsRef: DatabaseReference!
    var ref: DatabaseReference!
    var user: UserProfile!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        IQKeyboardManager.shared.enable = true
        
        var navigationController = storyboard.instantiateViewController(withIdentifier: "selectTestNavBar") as! UINavigationController
        
        if RootViewController.rootViewController == "" {
            return

        } else {
            
            let rootViewController = storyboard.instantiateViewController(identifier: RootViewController.rootViewController ?? "registrationVC")
            navigationController.viewControllers = [rootViewController]
//
//            navigationController = UINavigationController(rootViewController: rootViewController)
//            navigationController.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.3893484473, blue: 0, alpha: 1)
//            navigationController.navigationBar.isTranslucent = false
//            navigationController.navigationBar.tintColor = .white
//            navigationController.navigationItem.backButtonTitle = "Назад"
//            navigationController.navigationBar.backItem?.title = "Назад"
//            navigationController.navigationItem.backBarButtonItem?.title = "Назад"
//            navigationController.navigationItem.leftBarButtonItem?.title = "Назад"
//            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//            navigationController.navigationBar.titleTextAttributes = textAttributes
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

