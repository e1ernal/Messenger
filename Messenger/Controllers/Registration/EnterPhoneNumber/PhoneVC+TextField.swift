//
//  PhoneVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import UIKit

// MARK: - Handle TextField changing
extension PhoneViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        continueButton.setState(textField.hasText ? .active : .inactive)
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = numberTextField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        numberTextField.text = newString.numberFormatter()
        return false
    }
}
