//
//  UserDefaults.swift
//  Messenger
//
//  Created by e1ernal on 10.01.2024.
//

import Foundation

enum UserDefaultsKey {
    case userToken
}

extension String {
    static func key(_ userDefaultsKey: UserDefaultsKey) -> String {
        switch userDefaultsKey {
        case .userToken:
            return "userToken"
        }
    }
}

extension UserDefaults {
    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.object(forKey: .key(.userToken)) != nil ? true : false
    }
    
    static func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: .key(.userToken))
    }
    
    static func loginUser(token: String) {
        UserDefaults.standard.set(token, forKey: .key(.userToken))
        loginInfo()
    }
    
    static func logOutUser() {
        UserDefaults.standard.removeObject(forKey: .key(.userToken))
        loginInfo()
    }
    
    static func loginInfo() {
        print("[User login information]")
        print("    " + "Logged-in".padding(toLength: 9, withPad: " ", startingAt: 0) + ": \(UserDefaults.isUserLoggedIn())")
        print("    " + "Token".padding(toLength: 9, withPad: " ", startingAt: 0) + ": \(UserDefaults.getUserToken() ?? "-")")
    }
}
