//
//  UserSettings.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case firstName
        case lastName
        case phoneNumber
        case rellayTestNumber
    }
    
    static var rellayTestNumber: Int! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.rellayTestNumber.rawValue) as? Int
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.rellayTestNumber.rawValue
            if let number = newValue {
                defaults.set(number, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    
    static var firstName: String! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.firstName.rawValue) as? String
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.firstName.rawValue
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var lastName: String! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.lastName.rawValue) as? String
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.lastName.rawValue
            if let last = newValue {
                defaults.set(last, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var phoneNumber: String! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.phoneNumber.rawValue) as? String
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.phoneNumber.rawValue
            if let number = newValue {
                defaults.set(number, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
