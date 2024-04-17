//
//  URLService.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

final class URLService {
    static let shared = URLService(); private init() {}

    // Parameters
    private let scheme = "http://"
    private let host = "45.131.41.158"
    private let api = "/api"
    
    /// Create URL with endpoint
    /// - Parameters:
    ///   - endPoint: Endpoint
    ///   - parameters: Query parameters
    /// - Returns: URL
    func createURL(endPoint: EndPoint, parameters: [String: String]? = nil) throws -> URL {
        let urlStr = scheme + host + api + endPoint.path
        
        guard let baseURL = URL(string: urlStr),
              var components = URLComponents(url: baseURL, 
                                             resolvingAgainstBaseURL: false) else {
            throw DescriptionError.error("Can't create a url from string")
        }
        
        if parameters != nil {
            components.queryItems = parameters?.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let url = components.url else {
            throw DescriptionError.error("Can't create a url with components")
        }
        
        return url
    }
    
    func createDownloadImageURL(parameters: String) throws -> URL {
        let urlStr = scheme + host + parameters
        
        guard let baseURL = URL(string: urlStr) else {
            throw DescriptionError.error("Can't create a url to download image")
        }
        
        return baseURL
    }
    
    func createWebSocketURL(chatId: Int) -> URL? {
        let urlString = "ws://\(host)/ws/direct_chat/\(chatId)/"
        return URL(string: urlString)
    }
}

enum Users {
    // GET Methods
    case me /* user info */
    case username /* check username */
    case search /* search users by username */
    
    // PATCH Methods
    case update /* update user data */
    
    // POST Methods
    case createUser /* create user */
    case createChat(Int) /* create a chat with user by his id */
    
    // DELETE Methods
    case delete /* delete user */
    
    var path: String {
        switch self {
        case .me:
            return "/me/"
        case .username:
            return "/username/"
        case .search:
            return "/search/"
        case .update:
            return "/update/"
        case .createUser:
            return "/"
        case let .createChat(id):
            return "/\(id)/direct_chats/"
        case .delete:
            return "/delete/"
        }
    }
}

enum Codes: String {
    // POST Methods
    case confirmCode = "/confirm/" /* check verification code */
    case requestCode = "/" /* request for phone number verification */
}

enum DirectChats {
    // GET Methods
    case direct_chats /* user chats */
    case get_messages(Int) /* user messages in chat */
    
    // POST Methods
    case send_message(Int) /* send message to chat */
    
    var path: String {
        switch self {
        case .direct_chats:
            return "/"
        case let .get_messages(id):
            return "/\(id)/messages/"
        case let .send_message(id):
            return "/\(id)/messages/"
        }
    }
}

enum EndPoint {
    case users(_ path: Users)
    case verificationCode(_ path: Codes)
    case direct_chats(_ path: DirectChats)
    
    var path: String {
        switch self {
        case .users(let path):
            return "/users" + path.path
        case .verificationCode(let path):
            return "/verification_codes" + path.rawValue
        case .direct_chats(let path):
            return "/direct_chats" + path.path
        }
    }
}
