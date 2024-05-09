//
//  KeyChain.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import Foundation
import Security

// MARK: - Storing user data
// - Storage is based on KeyChain
final class Storage {
    static let shared = Storage(); private init() {}
    
    enum Service: String, CaseIterable {
        case token = "Token"
        case user = "User"
        case chats = "Chats"
        case publicKey = "PublicKey"
        case privateKey = "PrivateKey"
        case symmetricKeys = "SymmetricKeys"
    }
    
    enum Account: String {
        case account = "Account"
    }
    
    // MARK: - CRUD Methods
    func save<T: Codable>(_ object: T, as service: Service, in account: Account) throws {
        let data = try encode(object)
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service.rawValue as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecValueData as String: data as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            throw DescriptionError.error("Can't save \(Print.objectInfo(object: object)) as \(service). Duplicate item")
        }
        
        guard status == errSecSuccess else {
            throw DescriptionError.error("Can't save \(Print.objectInfo(object: object)) as \(service). Unexpected status: \(status)")
        }
    }
    
    func update<T: Codable>(_ object: T, as service: Service, in account: Account) throws {
        let data = try encode(object)
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service.rawValue as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        let attributes: [String: AnyObject] = [
            kSecValueData as String: data as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary,
                                   attributes as CFDictionary)

        guard status != errSecItemNotFound else {
            throw DescriptionError.error("Can't update \(object) as  \(service). Item not found")
        }

        guard status == errSecSuccess else {
            throw DescriptionError.error("Can't update \(object) as  \(service). Unexpected status: \(status)")
        }
    }
    
    func get<T: Decodable>(service: Service, as type: T.Type, in account: Account) throws -> T {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service.rawValue as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary,
                                         &itemCopy)

        guard status != errSecItemNotFound else {
            throw DescriptionError.error("Can't get item \(service) as \(type). Item not found")
        }
        
        guard status == errSecSuccess else {
            throw DescriptionError.error("Can't get item \(service) as \(type). Unexpected status: \(status)")
        }

        guard let data = itemCopy as? Data else {
            throw DescriptionError.error("Can't get item \(service) as \(type). Invalid item format")
        }
        
        return try decode(data, as: T.self)
    }
    
    func delete(service: Service, in account: Account) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service.rawValue as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            throw DescriptionError.error("Can't delete \(service.rawValue). Unexpected status: \(status)")
        }
        print("Storage: \(service.rawValue) has been deleted")
    }
}
