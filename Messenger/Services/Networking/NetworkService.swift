//
//  NetworkService.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService(); private init() { }
    
    // MARK: - GET methods
    func getUserInfo() {
        // TODO: - Create request
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
            throw NetworkError.errorUsername
        }
    }
    
    // MARK: - POST methods
    func createUser(username: String, firstname: String, lastname: String?, image: UIImage) async throws {
        guard let imageBase64 = image.jpegData(compressionQuality: 1)?.base64EncodedString() else {
            throw NetworkError.errorRequest
        }
        
        let user = User.UserDTO(first_name: firstname, 
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
        print("statusCode: \(statusCode)")
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(Token.self, from: data)
        print(result)
        guard statusCode == 200 else {
            throw NetworkError.errorRequest
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
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        print("statusCode: \(statusCode)")
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(Code.self, from: data)
        print(result)
        guard statusCode == 200 else {
            throw NetworkError.errorRequest
        }
        return result.code
    }
    
    func confirmVerificationCode(code: String) async throws {
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
        let result = try decoder.decode(CodeResponse.self, from: data)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponse
        }
        guard statusCode == 200 else {
            throw NetworkError.errorRequest
        }
    }
}
