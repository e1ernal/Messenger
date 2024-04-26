//
//  Author.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation

// MARK: - Author
struct Author: Codable {
    let id: Int
    let username, firstName, lastName, image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case image = "image"
    }
}
