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
        guard let newUsername = textField.text else {
            updatedUsername = nil
            navigationItem.rightBarButtonItem?.tintColor = .inactive
            return
        }
        
        // Check username availability
        Task {
            var isUsernameAvailable = false
            do {
                try await NetworkService.shared.checkUsername(newUsername)
                updatedUsername = newUsername
                isUsernameAvailable = true
            } catch {
                updatedUsername = nil
            }
            
            let buttonColor: UIColor = isUsernameAvailable ? .color(.active) : .color(.inactive)
            let textFieldColor: UIColor = isUsernameAvailable ? .color(.success) : .color(.failure)

            UIView.animate(withDuration: 0.25) {
                self.navigationItem.rightBarButtonItem?.tintColor = buttonColor
                textField.textColor = textFieldColor
            }
        }
    }
}
