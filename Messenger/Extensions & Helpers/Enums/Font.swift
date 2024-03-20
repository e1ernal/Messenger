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
    case secondaryTitle
    case subtitle
    case subtitleBold
    case body
    case header
    case mini
    case appName
    
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
        case .appName:
            return .systemFont(ofSize: CGFloat(30), weight: .bold)
        case .title:
            return .systemFont(ofSize: CGFloat(25), weight: .bold)
        case .secondaryTitle:
            return .systemFont(ofSize: CGFloat(18), weight: .bold)
        case .subtitle:
            return .systemFont(ofSize: CGFloat(15), weight: .regular)
        case .subtitleBold:
            return .systemFont(ofSize: CGFloat(15), weight: .bold)
        case .button:
            return .systemFont(ofSize: CGFloat(15), weight: .semibold)
        case .header:
            return .systemFont(ofSize: CGFloat(11), weight: .medium)
        case .body:
            return .systemFont(ofSize: CGFloat(13), weight: .regular)
        case .mini:
            return .systemFont(ofSize: CGFloat(9), weight: .medium)
        case .textField:
            return .systemFont(ofSize: CGFloat(18), weight: .regular)
        case .codeField:
            return .systemFont(ofSize: CGFloat(25), weight: .bold)
        }
    }
}
