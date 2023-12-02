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
        button.setTitle("→ LoginVC", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(loginVCButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    private func makeUI() {
        title = "StartVC"
        view.backgroundColor = .systemBackground
        
        view.addSubview(loginVCButton)
        
        NSLayoutConstraint.activate([
            loginVCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginVCButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginVCButton.widthAnchor.constraint(equalToConstant: view.frame.width * 2/3)
        ])
    }
    
    @objc private func loginVCButtonPressed() {
        let nextVC = LoginVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
