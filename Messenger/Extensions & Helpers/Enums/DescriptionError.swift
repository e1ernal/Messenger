//
//  CustomError.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import Foundation

enum DescriptionError: Error, LocalizedError {
    case error(String)
    
    var errorDescription: String? {
        switch self {
        case .error(let description):
            return NSLocalizedString(description, bundle: .main, comment: "")
        }
    }
}
