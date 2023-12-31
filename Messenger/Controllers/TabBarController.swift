//
//  TabBarController.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    static let nameVC: String = "TabBarController"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.chats, .settings]

        self.viewControllers = dataSource.map { viewController in
            switch viewController {
            case .chats:
                let chats = ChatsVC()
                chats.tabBarItem.title = TabBarItem.chats.title
                chats.tabBarItem.image = UIImage(systemName: TabBarItem.chats.iconName)
                return chats
            case .settings:
                let settings = SettingsVC()
                settings.tabBarItem.title = TabBarItem.settings.title
                settings.tabBarItem.image = UIImage(systemName: TabBarItem.settings.iconName)
                return settings
            }
        }
    }
}
