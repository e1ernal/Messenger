//
//  Message.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation

// MARK: - Message
struct Message: Codable {
    let author: Author
    let directId: Int
    let text: String
    let createdAt, updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case directId = "direct"
        case text = "text"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
