//
//  ViewController.swift
//  Messenger
//
//  Created by e1ernal on 21.11.2023.
//

import UIKit

class StartVC: UIViewController {
    let heightConstraint: CGFloat = 40.0
    let widthConstraint: CGFloat = 10.0
    var buttonColor: UIColor = .systemGray
    var buttonAlpha: Double = 0.5
    
    private lazy var loginVCButton: UIButton = {
       let button = UIButton()
        button.setTitle("  → Login", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(loginVCButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tabBarControllerButton: UIButton = {
       let button = UIButton()
        button.setTitle("  → Tab Bar", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(tabBarControllerButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginConfirmButton: UIButton = {
       let button = UIButton()
        button.setTitle("  → Login Confirmation", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(loginConfirmButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginVCButton, tabBarControllerButton, loginConfirmButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    private func makeUI() {
        title = "StartVC"
        view.backgroundColor = .systemBackground
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2/3)
        ])
    }
    
    @objc private func loginVCButtonPressed() {
        let nextVC = LoginVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func tabBarControllerButtonPressed() {
        let nextVC = TabBarController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func loginConfirmButtonPressed() {
        let nextVC = LoginConvirmVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
