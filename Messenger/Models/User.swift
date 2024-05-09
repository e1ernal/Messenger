//
//  User.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import UIKit

struct User: Codable {
    init(id: Int, firstName: String, lastName: String, image: UIImage, phoneNumber: String, username: String, publicKey: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.image = image
        self.phoneNumber = phoneNumber
        self.username = username
        self.publicKey = publicKey
    }
    
    var id: Int
    var firstName: String
    var lastName: String
    @CodableImage var image: UIImage
    var phoneNumber: String
    var username: String
    var publicKey: String
    
    func info() -> String {
        return """
                User:
                    id: \(id)
                    name: \(firstName) \(lastName)
                    phone number: \(phoneNumber)
                    username: \(username)
                    public key: \(publicKey.prefix(20))...
                """
    }
}

struct UserPost: Codable {
    let first_name: String?
    let last_name: String?
    let image: String?
    let username: String?
}

struct UserGet: Identifiable, Codable {
    let id: Int
    let first_name: String
    let username: String
    let last_name: String?
    let phone_number: String
    let public_key: String
    let image: String
}

struct UserUpdate: Identifiable, Codable {
    let id: Int
    let first_name: String
    let username: String
    let last_name: String?
    let image: String
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

struct UserId: Codable {
    let id: Int
}

struct EncryptedKey: Codable {
    let encryptedSymmetricKey: String
    
    enum CodingKeys: String, CodingKey {
        case encryptedSymmetricKey = "hasher_symmetric_key"
    }
}
