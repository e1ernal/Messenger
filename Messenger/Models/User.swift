//
//  User.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

// TODO: - раскидать по файлам
struct User: Identifiable, Decodable {
    var id: Int
    let firstName: String
    let username: String
    let lastName: String?
    let phoneNumber: String
    let image: String
    
    var dto: UserDTO {
        return UserDTO(firstName: firstName,
                       username: username,
                       lastName: lastName,
                       phoneNumber: phoneNumber,
                       image: image)
    }
    
    struct UserDTO: Encodable {
        let firstName: String
        let username: String
        let lastName: String?
        let phoneNumber: String
        let image: String
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
