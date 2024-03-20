//
//  NetworkService.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService(); private init() {}
    
    // MARK: - GET Methods
    
    /// Get user data by token
    func getUserInfo(token: String) async throws -> UserGet {
        let url = try URLService.shared.createURL(endPoint: .users(.me))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserGet.self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    func getUserImage(imagePath: String) async throws -> UIImage {
        let url = try URLService.shared.createDownloadImageURL(parameters: imagePath)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw DescriptionError.error("Can't convert image data to UIImage")
        }
        
        return image
    }
    
    func searchUsersByUsername(username: String, token: String) async throws -> [UserGet] {
        let url = try URLService.shared.createURL(endPoint: .users(.search), 
                                                  parameters: ["search": username])
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw DescriptionError.error("Status Code: \(statusCode)")
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([UserGet].self, from: data)
    }
    
    /// Check if the username is free
    func checkUsername(_ username: String) async throws {
        let url = try URLService.shared.createURL(endPoint: .users(.username),
                                                  parameters: ["username": username])
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
    }
    
    func deleteUser(token: String) async throws {
        let url = try URLService.shared.createURL(endPoint: .users(.delete))
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 204 else {
            print("Status Code: \(statusCode)")
            throw DescriptionError.error("Can't delete user")
        }
    }
    
    func getChats(token: String) async throws -> [Chat] {
        let url = try URLService.shared.createURL(endPoint: .direct_chats(.direct_chats))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Chat].self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    func getMessages(chatId: String, token: String) async throws -> [Message] {
        let url = try URLService.shared.createURL(endPoint: .direct_chats(.get_messages(chatId)))
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 201 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Message].self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    // MARK: - POST Methods
    func createUser(username: String, firstname: String, lastname: String?, image: UIImage) async throws -> String {
        guard let imageBase64 = image.jpegData(compressionQuality: 1)?.base64EncodedString() else {
            throw NetworkError.errorEncoding
        }
        
        let user = UserPost(first_name: firstname,
                            last_name: lastname,
                            image: "data:image/png;base64," + imageBase64,
                            username: username)
        
        let url = try URLService.shared.createURL(endPoint: .users(.createUser))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(user)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 201 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Token.self, from: data)
            print("Result 'token': \(result.token)")
            return result.token
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    func getVerificationCode(phoneNumber: String) async throws -> String {
        let url = try URLService.shared.createURL(endPoint: .verificationCode(.requestCode))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        
        let number = PhoneNumber(phone_number: phoneNumber)
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(number)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 || statusCode == 201 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let result = try decoder.decode(Code.self, from: data)
            print("Result 'code': \(result.code)")
            return result.code
        } catch {
            throw NetworkError.errorDecoding
        }
    }
    
    func confirmVerificationCode(code: String) async throws -> String? {
        let url = try URLService.shared.createURL(endPoint: .verificationCode(.confirmCode))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        
        let codeDTO = Code(code: code)
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(codeDTO)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        switch statusCode {
        case 200:
            do {
                let result = try decoder.decode(Token.self, from: data)
                return result.token
            } catch {
                print("No Result as 'Token'")
                throw NetworkError.errorDecoding
            }
        case 204:
            return nil
        default:
            print("StatusCode: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
    }
    
    func createChatWithUser(userId: Int, token: String) async throws {
        let url = try URLService.shared.createURL(endPoint: .users(.createChat(userId)))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let key = EncryptedKey(encrypted_key: "123")
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(key)
        request.httpBody = body
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 201 else {
            print("StatusCode: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
    }
    
    // MARK: - PATCH Methods
    func updateUserUsername(username: String, token: String) async throws -> UserUpdate {
        let user = UserPost(first_name: nil,
                            last_name: nil,
                            image: nil,
                            username: username)
        
        let url = try URLService.shared.createURL(endPoint: .users(.update))
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(user)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserUpdate.self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }

    func updateUser(username: String?, firstname: String?, lastname: String?, image: UIImage?, token: String) async throws -> UserUpdate {
        guard let imageBase64 = image?.jpegData(compressionQuality: 1)?.base64EncodedString() else {
            throw NetworkError.errorEncoding
        }
        
        let user = UserPost(first_name: firstname,
                            last_name: lastname,
                            image: "data:image/png;base64," + imageBase64,
                            username: username ?? "")
        
        let url = try URLService.shared.createURL(endPoint: .users(.update))
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("Token " + token, forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(user)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        
        guard statusCode == 200 else {
            print("Status Code: \(statusCode)")
            throw NetworkError.errorStatusCode
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserUpdate.self, from: data)
        } catch {
            throw NetworkError.errorDecoding
        }
    }
}
