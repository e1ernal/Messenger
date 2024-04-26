//
//  User.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import UIKit

struct User: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    @CodableImage var image: UIImage
    var phoneNumber: String
    var username: String
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
    let encrypted_key: String
}
