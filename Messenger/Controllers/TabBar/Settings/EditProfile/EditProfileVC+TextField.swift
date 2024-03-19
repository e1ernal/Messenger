//
//  EditProfileVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

// MARK: - Configure Text Field
extension EditProfileViewController: UITextFieldDelegate {
    internal func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if let newFirstName = textField.text {
                updatedUser.firstName = newFirstName
            } else {
                updatedUser.firstName = nil
            }
            
        case 1:
            if let newLastName = textField.text {
                updatedUser.lastName = newLastName
            } else {
                updatedUser.lastName = nil
            }
        default: 
            return
        }
        
        updateSaveButtonState()
    }
}
