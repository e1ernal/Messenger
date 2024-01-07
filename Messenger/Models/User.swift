//
//  User.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let firstName: String
    let username: String
    let lastName: String?
    let phoneNumber: String
    let image: String
    
    var dto: UserDTO {
        return UserDTO(first_name: firstName,
                       last_name: lastName,
                       image: image,
                       username: username)
    }
    
    struct UserDTO: Encodable {
        let first_name: String
        let last_name: String?
        let image: String
        let username: String
    }
}

struct PhoneNumber: Codable {
    let phone_number: String
}

struct Code: Codable {
    let code: String
}

struct CodeResponse: Codable {
    let response: Bool
}

struct Token: Codable {
    let token: String
}
