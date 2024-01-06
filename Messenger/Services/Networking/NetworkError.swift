//
//  NetworkError.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

enum NetworkError: Error {
    case errorURL
    case errorRequest
    case errorResponse
    case errorDecoding
    case errorUsername
    
    var description: String {
        switch self {
        case .errorURL:
            return "errorURL"
        case .errorRequest:
            return "errorRequest"
        case .errorResponse:
            return "errorResponse"
        case .errorDecoding:
            return "errorDecoding"
        case .errorUsername:
            return "errorUsername"
        }
    }
}
