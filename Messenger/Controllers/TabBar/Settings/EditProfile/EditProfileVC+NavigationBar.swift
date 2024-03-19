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
        guard let firstName = updatedUser.firstName,
              let lastName = updatedUser.lastName,
              let image = updatedUser.image else {
            return
        }
        
        guard !firstName.isEmpty else {
            return
        }
        
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                
                _ = try await NetworkService.shared.updateUser(username: "",
                                                               firstname: firstName,
                                                               lastname: lastName,
                                                               image: image,
                                                               token: token)
                
                let oldUser = try Storage.shared.get(service: .user, as: User.self, in: .account)
                let newUser = User(id: oldUser.id,
                                   firstName: firstName,
                                   lastName: lastName,
                                   image: image,
                                   phoneNumber: oldUser.phoneNumber,
                                   username: oldUser.username)
                
                try Storage.shared.update(newUser, as: .user, in: .account)
                navigate(.back)
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
    
    internal func updateSaveButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = updatedUser.firstName != nil && updatedUser.lastName != nil
    }
}
