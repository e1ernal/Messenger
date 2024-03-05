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
    private var firstItemImageView = UIImageView()
    private var secondItemImageView = UIImageView()
    private let user: User
    
    // MARK: - Init UITabBarController
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let dataSource: [TabBarItem] = [.chats, .settings]
        
        self.viewControllers = dataSource.map { controller in
            switch controller {
            case .chats:
                let chats = ChatsViewController(style: .insetGrouped)
                chats.title = dataSource[0].title
                return UINavigationController(rootViewController: chats)
            case .settings:
                let settings = SettingsViewController(user: user)
                settings.title = dataSource[1].title
                return UINavigationController(rootViewController: settings)
            }
        }
        
        self.viewControllers?.enumerated().forEach { index, controller in
            controller.tabBarItem.tag = index
            controller.tabBarItem.title = dataSource[index].title
            controller.tabBarItem.image = UIImage(systemName: dataSource[index].iconName)
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
        
        let firstItemView = self.tabBar.subviews[0]
        let secondItemView = self.tabBar.subviews[1]
        
        guard let firstItem = firstItemView.subviews.first as? UIImageView,
              let secondItem = secondItemView.subviews.first as? UIImageView else {
            return
        }
        firstItemImageView = firstItem
        secondItemImageView = secondItem
        firstItemImageView.contentMode = .center
        secondItemImageView.contentMode = .center
    }
    
    /// Show tabBar animation on tap
    /// - Parameters:
    ///   - tabBar: Chats & Settings tabBar
    ///   - item: Chats or Settings item
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard selectedIndex != item.tag else {
            return
        }
        
        switch item.tag {
        case 0:
            self.firstItemImageView.transform = CGAffineTransform.identity
            UIView.animate(
                withDuration: 0.15,
                animations: {
                    self.firstItemImageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.55,
                        delay: 0,
                        usingSpringWithDamping: 0.5,
                        initialSpringVelocity: 1,
                        options: .curveEaseInOut,
                        animations: {
                            self.firstItemImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },
                        completion: nil)
                }
            )
        case 1:
            self.secondItemImageView.transform = CGAffineTransform.identity
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: .curveEaseInOut,
                animations: {
                    () -> Void in
                    let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
                    self.secondItemImageView.transform = rotation
                },
                completion: nil
            )
        default:
            return
        }
    }
}
