//
//  AppDelegate.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        FirebaseApp.configure()
        
//        UNUserNotificationCenter.current().delegate = self
//        let center = UNUserNotificationCenter.current()
//
//           center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//               if granted {
//                   print("Yay!")
//               } else {
//                   print("D'oh")
//               }
//           }
//
//        let content = UNMutableNotificationContent()
//        content.title = "Время пройти тест!"
//        content.body = "Вы получили доступ к новому тесту."
//        content.categoryIdentifier = "ьб"
//        content.userInfo = ["ьб": "бь"]
//        content.sound = .default
//
//        var dateComponents = DateComponents()
//        dateComponents.hour = 11
//        dateComponents.minute = 14
//        //           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
//        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.setNotificationCategories([category])
//        center.add(request)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound, .badge])
//    }


}


let App = AppDelegate()
