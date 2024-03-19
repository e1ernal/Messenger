//
//  UsernameVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import UIKit

// MARK: - Handle TextField changing
extension UsernameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText, let username = textField.text else {
            continueButton.setState(.inactive)
            UIView.animate(withDuration: 0.25) {
                self.usernameTextField.layer.borderColor = .color(.background)
            }
            return
        }
        
        // Check username availability
        Task {
            do {
                try await NetworkService.shared.checkUsername(username)
                isUsernameAvailable = true
            } catch {
                isUsernameAvailable = false
            }
            
            // Set color state to UI based on username availability
            let buttonState: ViewState = isUsernameAvailable ? .active : .inactive
            let fieldColor: CGColor = isUsernameAvailable ? .color(.success) : .color(.failure)
            
            UIView.animate(withDuration: 0.25) {
                self.usernameTextField.layer.borderColor = fieldColor
            }
            continueButton.setState(buttonState)
        }
    }
}
