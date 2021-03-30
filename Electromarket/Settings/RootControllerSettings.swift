//
//  UserSettings.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import Foundation

final class RootViewController {
    
    private enum SettingsKeys: String {
        case rootViewController
    }
    
    static var rootViewController: String! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.rootViewController.rawValue) as? String
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.rootViewController.rawValue
            if let rootVC = newValue {
                defaults.set(rootVC, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
