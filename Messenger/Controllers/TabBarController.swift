//
//  TabBarController.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case contacts
        case chats
        case settings
        var title: String {
            switch self {
            case .contacts:
                return "Contacts"
            case .chats:
                return "Chats"
            case .settings:
                return "Settings"
            }
        }
        var iconName: String {
            switch self {
            case .contacts:
                return "person.crop.circle"
            case .chats:
                return "ellipsis.message.fill"
            case .settings:
                return "gear"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.contacts, .chats, .settings]
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .contacts:
                let contactsVC = ContactsVC()
                return self.wrappedInNavigationController(with: contactsVC, title: $0.title)
            case .chats:
                let chatsVC = ChatsVC()
                return self.wrappedInNavigationController(with: chatsVC, title: $0.title)
            case .settings:
                let settingsVC = SettingsVC()
                return self.wrappedInNavigationController(with: settingsVC, title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }
}
