//
//  User.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import UIKit

@propertyWrapper
public struct CodableImage: Codable {
    var image: UIImage
    
    public enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.image,
                                                   in: container,
                                                   debugDescription: "Decoding image failed")
        }
        
        self.image = image
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = image.pngData()
        try container.encode(data, forKey: CodingKeys.image)
    }
    
    public init(wrappedValue: UIImage) {
        self.init(image: wrappedValue)
    }
    
    public var wrappedValue: UIImage {
        get { image }
        set { image = newValue }
    }
}

struct User: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    @CodableImage var image: UIImage
    var phoneNumber: String
    var username: String
    
    func print() {
        Swift.print( """
                    [User]:
                        - first name   : \(firstName)
                        - last name    : \(lastName)
                        - username     : @\(username)
                        - phone number : \(phoneNumber)
                        - image        : \(String(describing: image.pngData()))
                    """
        )
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

// MARK: - Chats
struct Chat: Codable {
    let username, firstName, lastName, image: String
    let lastMessage: String?
    let lastMessageCreated: Int?
    let created: Int
    let directId: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case image = "image"
        case lastMessage = "last_message"
        case lastMessageCreated = "last_message_created"
        case created = "created_at"
        case directId = "direct_id"
    }
}

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
