//
//  EditUsernameVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

// MARK: - Handle TextField did change
extension EditUsernameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText,
              let newUsername = textField.text,
              newUsername != username
        else {
            updatedUsername.isAvailable = false
            navigationItem.rightBarButtonItem?.tintColor = .inactive
            return
        }
        
        // Check username availability
        Task {
            do {
                try await NetworkService.shared.checkUsername(newUsername)
                updatedUsername.isAvailable = true
                updatedUsername.username = newUsername
            } catch {
                updatedUsername.isAvailable = false
            }
            
            let buttonColor: UIColor = updatedUsername.isAvailable ? .color(.active) : .color(.inactive)
            let textFieldColor: UIColor = updatedUsername.isAvailable ? .color(.success) : .color(.failure)

            UIView.animate(withDuration: 0.25) {
                self.navigationItem.rightBarButtonItem?.tintColor = buttonColor
                textField.textColor = textFieldColor
            }
        }
    }
}
