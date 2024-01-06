//
//  Font.swift
//  Messenger
//
//  Created by e1ernal on 05.01.2024.
//

import UIKit

enum Font {
    // Label
    case large
    case title
    case subtitle
    case subtitleBold
    case body
    
    // Button
    case button
    
    // TextField
    case textField
    case codeField
}

extension UIFont {
    static func font(_ font: Font) -> UIFont {
        switch font {
        case .large:
            return .systemFont(ofSize: CGFloat(70), weight: .heavy)
        case .title:
            return .systemFont(ofSize: CGFloat(25), weight: .bold)
        case .subtitle:
            return .systemFont(ofSize: CGFloat(15), weight: .regular)
        case .subtitleBold:
            return .systemFont(ofSize: CGFloat(15), weight: .bold)
        case .button:
            return .systemFont(ofSize: CGFloat(15), weight: .semibold)
        case .body:
            return .systemFont(ofSize: CGFloat(13), weight: .regular)
        case .textField:
            return .systemFont(ofSize: CGFloat(18), weight: .regular)
        case .codeField:
            return .systemFont(ofSize: CGFloat(25), weight: .bold)
        }
    }
}
