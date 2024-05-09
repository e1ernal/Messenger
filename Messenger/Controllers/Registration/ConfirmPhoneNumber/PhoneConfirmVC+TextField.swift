//
//  PhoneConfirmVC+TextField.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import UIKit

// MARK: - Handle TextField changing
extension PhoneConfirmViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count <= digitsCount else { return }
        
        for digitIndex in 0 ..< digitsCount {
            let currentLabel = digitLabels[digitIndex]
            
            if digitIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: digitIndex)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderColor = .color(.active)
            } else {
                currentLabel.text?.removeAll()
                currentLabel.layer.borderColor = .color(.inactive)
            }
        }
        
        if text.count == digitsCount {
            Task {
                do {
                    // MARK: - Сheck whether the user has a token
                    // Generate Private and Public Keys
                    let keys = try AsymmetricEncryption.shared.generateKeys()
                    
                    try Storage.shared.save(keys.publicKey, as: .publicKey, in: .account)
                    try Storage.shared.save(keys.privateKey, as: .privateKey, in: .account)
                    
                    guard let token = try await NetworkService.shared.confirmVerificationCode(code: text, publicKey: keys.publicKey) else {
                        // The user does not have an account, he continues to register
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigate(.next(ProfileInfoViewController(), .fullScreen))
                        }
                        return
                    }
                    
                    // The user has an account. Receive his data
                    for label in digitLabels {
                        label.layer.borderColor = .color(.success)
                    }
                    
                    try Storage.shared.save(token, as: .token, in: .account)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let nextVC = LaunchScreenVC(greeting: "Welcome")
                        self.navigate(.root(nextVC))
                    }
                } catch {
                    Print.error(screen: self, action: #function, reason: error, show: true)
                    for label in digitLabels {
                        label.layer.borderColor = .color(.failure)
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitsCount || string.isEmpty
    }
}
