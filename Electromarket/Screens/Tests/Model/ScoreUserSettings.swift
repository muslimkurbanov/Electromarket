//
//  ScoreUserSettings.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import Foundation

final class ScoreSettings {
    
    private enum SettingsKeys: String {
        case relayResults
        case stabilizerResults
  
    }
     
    static var relayResults: Int! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.relayResults.rawValue) as? Int
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.relayResults.rawValue
            if let relay = newValue {
                print("Value \(relay) was added to key \(key)")
                defaults.set(relay, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var stabilizerResults: Int! {
        get {
            return UserDefaults.standard.object(forKey: SettingsKeys.stabilizerResults.rawValue) as? Int
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.stabilizerResults.rawValue
            if let stabilizer = newValue {
                print("Value \(stabilizer) was added to key \(key)")
                defaults.set(stabilizer, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}
