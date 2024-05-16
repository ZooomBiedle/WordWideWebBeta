//
//  UserDefaults.swift
//  WordWideWeb
//
//  Created by David Jang on 5/16/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let isAutoLoginEnabled = "isAutoLoginEnabled"
        static let googleIDToken = "googleIDToken"
        static let googleAccessToken = "googleAccessToken"
        static let appleIDToken = "appleIDToken"
        static let appleNonce = "appleNonce"
    }
    
    var isLoggedIn: Bool {
        get {
            return bool(forKey: Keys.isLoggedIn)
        }
        set {
            set(newValue, forKey: Keys.isLoggedIn)
        }
    }
    
    var isAutoLoginEnabled: Bool {
        get {
            return bool(forKey: Keys.isAutoLoginEnabled)
        }
        set {
            set(newValue, forKey: Keys.isAutoLoginEnabled)
        }
    }

    var googleIDToken: String? {
        get {
            return string(forKey: Keys.googleIDToken)
        }
        set {
            set(newValue, forKey: Keys.googleIDToken)
        }
    }
    
    var googleAccessToken: String? {
        get {
            return string(forKey: Keys.googleAccessToken)
        }
        set {
            set(newValue, forKey: Keys.googleAccessToken)
        }
    }

    var appleIDToken: String? {
        get {
            return string(forKey: Keys.appleIDToken)
        }
        set {
            set(newValue, forKey: Keys.appleIDToken)
        }
    }

    var appleNonce: String? {
        get {
            return string(forKey: Keys.appleNonce)
        }
        set {
            set(newValue, forKey: Keys.appleNonce)
        }
    }
}
