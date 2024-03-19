//
//  Storage+Helpers.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import Foundation

extension Storage {
    func isLoggedIn() -> Bool {
        do {
            _ = try get(service: .token, as: String.self, in: .account)
            return true
        } catch {
            return false
        }
    }
    
    func logOut() throws {
        do {
            try Storage.shared.delete(service: .token, in: .account)
            try Storage.shared.delete(service: .user, in: .account)
            try Storage.shared.delete(service: .chats, in: .account)
        } catch {
            throw error
        }
    }
}
