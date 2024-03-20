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
    
    func getChatsData() async throws {
        let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
        let chats = try await NetworkService.shared.getChats(token: token)
        do {
            try Storage.shared.save(chats, as: .chats, in: .account)
        } catch {
            try Storage.shared.update(chats, as: .chats, in: .account)
        }
    }
    
    func getUserData() async throws {
        let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
        let userGet = try await NetworkService.shared.getUserInfo(token: token)
        let image = try await NetworkService.shared.getUserImage(imagePath: userGet.image)
        
        let user = User(id: userGet.id,
                        firstName: userGet.first_name,
                        lastName: userGet.last_name ?? "",
                        image: image,
                        phoneNumber: userGet.phone_number.numberFormatter(),
                        username: userGet.username)
        
        do {
            try Storage.shared.save(user, as: .user, in: .account)
        } catch {
            try Storage.shared.update(user, as: .user, in: .account)
        }
    }
}
