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
        } catch { return false }
    }
    
    func logOut() {
        let services = Service.allCases
        services.forEach { service in
            do { try Storage.shared.delete(service: service, in: .account) } catch {}
        }
    }
    
    func showAllData() {
        print("Storage:")
        let services = Service.allCases
        services.forEach { service in
            let type: Codable.Type
            switch service {
            case .user:
                type = User.self
            case .chats:
                type = [Chat].self
            case .symmetricKeys:
                type = ChatSymmetricKey.self
            default:
                type = String.self
            }
            do {
                let object = try Storage.shared.get(service: service, as: type, in: .account)
                if type == String.self {
                    print("- \(service.rawValue): \(Print.objectInfo(object: object))")
                } else {
                    print("- \(service.rawValue): \(Print.objectInfo(object: object, spacer: "    "))")
                }
            } catch {
                print("- \(service.rawValue): -")
            }
        }
    }
    
    func getChatsData() async throws {
        let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
        let chats = try await NetworkService.shared.getChats(token: token)
        
        do { try Storage.shared.save(chats, as: .chats, in: .account)
        } catch { try Storage.shared.update(chats, as: .chats, in: .account) }
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
                        username: userGet.username,
                        publicKey: userGet.public_key)
        
        do { try Storage.shared.save(user, as: .user, in: .account)
        } catch { try Storage.shared.update(user, as: .user, in: .account) }
    }
}
