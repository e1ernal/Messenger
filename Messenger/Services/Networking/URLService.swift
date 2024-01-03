//
//  URLService.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

final class URLService {
    static let shared = URLService(); private init() { }

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
}

enum Users: String {
    /// GET - user info
    case me = "/me/"
    /// GET - check username
    case username = "/username/"
    /// POST - create user without path
    case createUser = "/"
}

enum Codes: String {
    /// POST - check verification code
    case confirmCode = "/confirm/"
    /// POST - request for phone number verification
    case requestCode = "/"
}

enum EndPoint {
    case users(path: Users)
    case verificationCode(path: Codes)

    var path: String {
        switch self {
        case .users(let path):
            return "/users" + path.rawValue
        case .verificationCode(let path):
            return "/verification_codes" + path.rawValue
        }
    }
}
