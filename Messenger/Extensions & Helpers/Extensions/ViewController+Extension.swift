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
    
    func popBackVC() {
        navigationController?.popViewController(animated: true)
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
    
    // MARK: - Setup basic View Controller
    /// - Parameters:
    ///     - title: Title to View Controller
    ///     - backButton: Show back button as navigationItem
    func setupVC(title: String?, backButton: Bool) {
        self.title = title
        view.backgroundColor = .color(.background)
        navigationItem.setHidesBackButton(!backButton, animated: true)
        hideKeyboardWhenTappedAround()
    }
}
