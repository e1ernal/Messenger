//
//  WelcomeVC.swift
//  Messenger
//
//  Created by e1ernal on 02.01.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    private let nameLabel = BasicLabel("Messenger", .font(.appName))
    private lazy var startButton = BasicButton(title: "Start Messaging", style: .filled(.active)) {
        self.navigate(.next(PhoneViewController(), .fullScreen))
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureVC(title: "", backButton: false)
        
        view.addSubview(nameLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            startButton.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.const(.doubleHeight)),
            startButton.heightAnchor.constraint(equalToConstant: .const(.height))
        ])
    }
}
