//
//  NetworkError.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case errorURL
    case errorRequest
    case errorResponse
    case errorDecoding
    case errorUsername
    case errorStatusCode
    case errorEncoding
    
    var errorDescription: String? {
        switch self {
        case .errorURL:
            return NSLocalizedString("Error: URL", bundle: .main, comment: "")
        case .errorRequest:
            return NSLocalizedString("Error: Request", bundle: .main, comment: "")
        case .errorResponse:
            return NSLocalizedString("Error: Response", bundle: .main, comment: "")
        case .errorDecoding:
            return NSLocalizedString("Error: Decoding", bundle: .main, comment: "")
        case .errorUsername:
            return NSLocalizedString("Error: Username", bundle: .main, comment: "")
        case .errorStatusCode:
            return NSLocalizedString("Error: Status code", bundle: .main, comment: "")
        case .errorEncoding:
            return NSLocalizedString("Error: Encoding", bundle: .main, comment: "")
        }
    }
}
