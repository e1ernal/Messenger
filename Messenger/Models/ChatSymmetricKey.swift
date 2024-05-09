//
//  ChatSymmetricKey.swift
//  Messenger
//
//  Created by e1ernal on 07.05.2024.
//

import Foundation

struct ChatSymmetricKey: Codable {
    private var symmetricKeys = [Int: String]()
    
    mutating func insert(chatId: Int, symmetricKey: String) {
        symmetricKeys[chatId] = symmetricKey
    }
    
    func getKey(chatId: Int) throws -> String {
        guard let symmetricKey = symmetricKeys[chatId] else {
            throw DescriptionError.error("Chat \(chatId) has no symmetric key")
        }
        return symmetricKey
    }
    
    func containsKey(chatId: Int) -> Bool {
        return symmetricKeys[chatId] == nil ? false : true
    }
}
