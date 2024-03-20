//
//  MessagesVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 20.03.2024.
//

import UIKit

// MARK: - Configure TextField
extension MessagesVC: UITextFieldDelegate {
    internal func configureTextField() {
        messageTextField.delegate = self
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty else {
            sendButton.tintColor = .inactive
            return
        }
        
        sendButton.tintColor = .active
    }
}
