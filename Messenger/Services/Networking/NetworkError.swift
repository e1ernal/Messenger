//
//  NetworkError.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

public enum NetworkError: Error {
    case errorURL
    case errorRequest
    case errorResponce
    case errorDecoding
    case errorUsername
    
    public var description: String {
        switch self {
        case .errorURL:
            return "errorURL"
        case .errorRequest:
            return "errorRequest"
        case .errorResponce:
            return "errorResponce"
        case .errorDecoding:
            return "errorDecoding"
        case .errorUsername:
            return "errorUsername"
        }
    }
}
