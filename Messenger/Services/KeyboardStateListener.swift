//
//  KeyboardStateListener.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import Foundation
import UIKit

class KeyboardStateListener {
    static let shared = KeyboardStateListener(); private init() {}
    
    var isVisible = false
    var keyboardHeight: CGFloat = 0.0
    
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        isVisible = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillHide() {
        isVisible = false
        keyboardHeight = 0.0
    }
    
    func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }
}
