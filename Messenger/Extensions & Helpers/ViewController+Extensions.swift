//
//  ViewController+Extensions.swift
//  Messenger
//
//  Created by e1ernal on 26.12.2023.
//

import UIKit

extension UIViewController: UNUserNotificationCenterDelegate {
    // MARK: - Navigation Controller actions
    func showNextVC(nextVC: UIViewController) {
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Keyboard actions
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
