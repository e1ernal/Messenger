//
//  Constraints.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

enum Constraint: CGFloat {
    case doubleHeight = 80.0
    case height = 40.0
    case doubleSpacing = 20.0
    case spacing = 10.0
}

enum Color {
    case background
    case secondaryBackground
    case transparentBackground
    case active
    case inactive
    case success
    case noSuccess
    
    var color: UIColor {
        switch self {
        case .background:
            return .systemBackground
        case .secondaryBackground:
            return .systemGray6
        case .transparentBackground:
            return .systemBackground.withAlphaComponent(0.5)
        case .active:
            return .systemBlue.withAlphaComponent(1.0)
        case .inactive:
            return .systemGray.withAlphaComponent(0.5)
        case .success:
            return .systemGreen.withAlphaComponent(1.0)
        case .noSuccess:
            return .systemRed.withAlphaComponent(1.0)
        }
    }
}

enum Font {
    case large
    case title
    case subtitle
    case subtitleBold
    case button
    case body
    
    var font: UIFont {
        switch self {
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
        }
    }
}

enum TabBarItem {
    case chats
    case settings
    
    var title: String {
        switch self {
        case .chats:
            return "Chats"
        case .settings:
            return "Settings"
        }
    }
    var iconName: String {
        switch self {
        case .chats:
            return "ellipsis.message.fill"
        case .settings:
            return "gear"
        }
    }
}
