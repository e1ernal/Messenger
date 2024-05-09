//
//  DirectChat.swift
//  Messenger
//
//  Created by e1ernal on 07.05.2024.
//

import Foundation

// MARK: - DirectChat
struct DirectChat: Codable {
    let id, createdAt: Int
    let encryptedSymmetricKey: String
    let isPrivate: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case encryptedSymmetricKey = "hasher_symmetric_key"
        case isPrivate = "is_private"
    }
    
    func info() -> String {
        return """
                id: \(id)
                encrypted symmetric key: \(encryptedSymmetricKey.prefix(20))...
                is private: \(isPrivate)
                """
    }
}
