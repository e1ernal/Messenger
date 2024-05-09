//
//  Chat.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation

// MARK: - Chats
struct Chat: Codable {
    let username, firstName, lastName, image: String
    let lastMessage: String?
    let lastMessageCreated: Int?
    let directChat: DirectChat

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case image = "image"
        case lastMessage = "last_message"
        case lastMessageCreated = "last_message_created"
        case directChat = "direct_chat"
    }
    
    func info() -> String {
        return """
                - Chat
                with user: \(firstName) \(lastName),  @\(username)
                last message: \(lastMessage?.prefix(10) ?? "-")...
                \(directChat.info())
                """
    }
}
