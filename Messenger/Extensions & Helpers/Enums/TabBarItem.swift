//
//  TabBarItem.swift
//  Messenger
//
//  Created by e1ernal on 05.01.2024.
//

import Foundation

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
