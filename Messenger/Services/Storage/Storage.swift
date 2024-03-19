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
    
    enum KeychainError: Error {
        case error_Item_Not_Found
        case error_Duplicate_Item
        case error_Invalid_Item_Format
        case error_Unexpected_Status(OSStatus)
        case error_Encoding
        case error_Decoding
    }
    
    enum Service: String {
        case token = "Token"
        case user = "User"
        case chats = "Chats"
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
            throw KeychainError.error_Duplicate_Item
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.error_Unexpected_Status(status)
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
            throw KeychainError.error_Item_Not_Found
        }

        guard status == errSecSuccess else {
            throw KeychainError.error_Unexpected_Status(status)
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
            throw KeychainError.error_Item_Not_Found
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.error_Unexpected_Status(status)
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.error_Invalid_Item_Format
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
            throw KeychainError.error_Unexpected_Status(status)
        }
        print("[Storage]: \(service.rawValue) has been deleted")
    }
}
