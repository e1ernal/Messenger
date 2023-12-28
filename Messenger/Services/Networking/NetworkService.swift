//
//  NetworkService.swift
//  Networking POST [Async Await]
//
//  Created by e1ernal on 24.12.2023.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService(); private init() { }
    
    // MARK: - GET methods
    func getUserInfo() {
        // TODO: - Create request
    }
    
    /// Check if the username is free
    func checkUsername(username: String) async throws {
        let url = try URLService.shared.createURL(endPoint: .users(path: .username),
                                                  parameters: ["username": username])
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.errorResponce
        }
        guard statusCode == 200 else {
            throw NetworkError.errorUsername
        }
    }
    
    // MARK: - POST methods
    func getVerificationCode(phoneNumber: String) async throws {
        do {
            let url = try URLService.shared.createURL(endPoint: .verificationCode(path: .requestCode))

            // Создание запроса
            var request = URLRequest(url: url)

            // Настройки запроса
            request.httpMethod = "POST"
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")

            let number = PhoneNumber(phone_number: phoneNumber)

            let encoder = JSONEncoder()
            let body = try encoder.encode(number)
            request.httpBody = body

            // Отправка запроса, получение ответа
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.errorResponce
            }
            print("statusCode: \(statusCode)")
            
            // Декодирование полученных данных в Swift-модель
            let decoder = JSONDecoder()
            let result = try decoder.decode(Code.self, from: data)
            print(result)
            guard statusCode == 200 else {
                throw NetworkError.errorRequest
            }
        }
    }

    func confirmVerificationCode(code: String) async throws {
        do {
            let url = try URLService.shared.createURL(endPoint: .verificationCode(path: .confirmCode))
            // Создание запроса
            var request = URLRequest(url: url)

            // Настройки запроса
            request.httpMethod = "POST"
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")

            let codeDTO = Code(code: code)

            let encoder = JSONEncoder()
            let body = try encoder.encode(codeDTO)
            request.httpBody = body

            // Отправка запроса, получение ответа
            let (data, response) = try await URLSession.shared.data(for: request)

            // Декодирование полученных данных в Swift-модель
            let decoder = JSONDecoder()
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.errorResponce
            }
            let result = try decoder.decode(CodeResponse.self, from: data)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.errorResponce
            }
            guard statusCode == 200 else {
                throw NetworkError.errorRequest
            }
        }
    }
}
