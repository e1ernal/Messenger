//
//  ProfileInfoVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import UIKit

// MARK: - Handle TextField changing
extension ProfileInfoViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? FloatingTextField else {
            return
        }
        
        let fieldState: ViewState = textField.hasText ? .active : .inactive
        textField.setState(fieldState)
        
        if textField === firstNameTextField {
            continueButton.setState(textField.hasText ? .active : .inactive)
        }
    }
}
