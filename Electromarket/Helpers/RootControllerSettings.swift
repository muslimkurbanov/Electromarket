//
//  UserSettings.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import Foundation

final class RootStoryboard {
    
    private enum SettingsKeys: String {
        case rootStoryboard
    }
    
    static var rootStoryboard: String! {
        get {
            
            return UserDefaults.standard.object(forKey: SettingsKeys.rootStoryboard.rawValue) as? String
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.rootStoryboard.rawValue
            
            if let rootSB = newValue {
                
                defaults.set(rootSB, forKey: key)
            } else {
                
                defaults.removeObject(forKey: key)
            }
        }
    }
}
