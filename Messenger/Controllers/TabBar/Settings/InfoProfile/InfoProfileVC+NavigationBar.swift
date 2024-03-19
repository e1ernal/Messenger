//
//  InfoProfileVC+NavigationBar.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Navigation Bar
extension InfoProfileViewController {
    internal func configureNavigationBar() {
        let editProfileAction = UIAction(title: "Edit profile", image: .systemImage(.edit, color: .label)) { _ in
            let nextVC = EditProfileViewController(style: .insetGrouped)
            self.navigate(.next(nextVC, .fullScreen))
        }
        
        let logOutAction = UIAction(title: "Log Out", image: .systemImage(.rightArrow, color: .label)) { _ in
            let nextVC = LogOutProfileViewController(style: .insetGrouped)
            self.navigate(.next(nextVC, .fullScreen))
        }
        
        let deleteAccountAction = UIAction(title: "Delete Account", image: .systemImage(.rightArrow, color: .failure), attributes: .destructive) { _ in
            let nextVC = DeleteProfileViewController(style: .insetGrouped)
            self.navigate(.next(nextVC, .fullScreen))
        }
        
        let submenu = UIMenu(title: "Account", image: .systemImage(.logOut, color: .label), children: [logOutAction, deleteAccountAction])
        let menu = UIMenu(title: "", children: [editProfileAction, submenu])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: .systemImage(.optionsDots, color: .active), menu: menu)
    }
}
