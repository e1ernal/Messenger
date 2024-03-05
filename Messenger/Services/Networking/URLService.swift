//
//  URLService.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

final class URLService {
    static let shared = URLService(); private init() {}

    private let scheme = "http://"
    private let host = "45.131.41.158"
    private let api = "/api"

    func createURL(endPoint: EndPoint, parameters: [String: String]? = nil) throws -> URL {
        let urlStr = scheme + host + api + endPoint.path
        guard let baseURL = URL(string: urlStr),
              var components = URLComponents(url: baseURL, 
                                             resolvingAgainstBaseURL: false) else {
            throw NetworkError.errorURL
        }

        components.queryItems = parameters?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        guard let url = components.url else {
            throw NetworkError.errorURL
        }
        
        return url
    }
    
    func createDownloadImageURL(parameters: String) throws -> URL {
        let urlStr = scheme + host + parameters
        
        guard let baseURL = URL(string: urlStr) else {
            throw NetworkError.errorURL
        }
        
        return baseURL
    }
}

enum Users: String {
    // GET Methods
    case me = "/me/" /* user info */
    case username = "/username/" /* check username */
    case search = "/search/" /* search users by username */
    
    // PATCH Methods
    case update = "/update/" /* update user data */
    
    // POST Methods
    case createUser = "/" /* create user */
    
    // DELETE Methods
    case delete = "/delete/" /* delete user */
}

enum Codes: String {
    // POST Methods
    case confirmCode = "/confirm/" /* check verification code */
    case requestCode = "/" /* request for phone number verification */
}

enum EndPoint {
    case users(_ path: Users)
    case verificationCode(_ path: Codes)

    var path: String {
        switch self {
        case .users(let path):
            return "/users" + path.rawValue
        case .verificationCode(let path):
            return "/verification_codes" + path.rawValue
        }
    }
}
