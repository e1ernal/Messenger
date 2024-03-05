//
//  EditProfileVC+NavigationBar.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Navigation Bar
extension EditProfileViewController {
    internal func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveTapped))
    }
    
    // Save and update user data
    @objc func saveTapped() {
        guard !user.firstName.isEmpty, !user.lastName.isEmpty else {
            return
        }
        
        Task {
            do {
                guard let userToken = UserDefaults.getUserToken() else {
                    throw DescriptionError.error("No user token")
                }
                
                _ = try await NetworkService.shared.updateUser(username: "",
                                                               firstname: user.firstName,
                                                               lastname: user.lastName,
                                                               image: user.image,
                                                               token: userToken)
                
                delegate?.updateUser(user: user)
                navigate(.back)
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
    
    internal func updateSaveButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = !user.firstName.isEmpty && !user.lastName.isEmpty
    }
}
