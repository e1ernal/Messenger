//
//  ProfileInfo.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

class ProfileInfoViewController: UIViewController {
    internal lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .constant(.imageCornerRadius)
        imageView.image = .assetImage(.addPhoto)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, 
                                                              action: #selector(showImagePickerControllerActionSheet)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = BasicLabel("Profile Info", .font(.title))
    private let subtitleLabel = BasicLabel("Enter your name and add a profile picture", .font(.subtitle))

    internal var firstNameTextField = FloatingTextField(placeholder: "First name (required)")
    private var lastNameTextField = FloatingTextField(placeholder: "Last name (optional)")
    
    internal lazy var continueButton = BasicButton(title: "Continue", style: .filled(.inactive)) {
        self.continueButtonTapped()
    }

    private let uiStackView = BasicStackView(.vertical, .constant(.spacing), nil, nil)
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        configureVC(title: "", backButton: false)
        
        uiStackView.addArrangedSubview(titleLabel)
        uiStackView.addArrangedSubview(subtitleLabel)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(firstNameTextField)
        uiStackView.addArrangedSubview(lastNameTextField)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: lastNameTextField)
        uiStackView.addArrangedSubview(continueButton)
        
        view.addSubview(userImageView)
        view.addSubview(uiStackView)
        
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: .constant(.imageHeight)),
            userImageView.widthAnchor.constraint(equalToConstant: .constant(.imageHeight)),
            
            uiStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: .constant(.spacing))
        ])
    }
    
    // MARK: - Actions
    @objc func continueButtonTapped() {
        guard firstNameTextField.hasText,
              let firstName = firstNameTextField.text else {
            self.showSnackBar(text: "Error: No user name", 
                              image: .systemImage(.warning, color: nil),
                              on: self)
            return
        }
        
        guard let image = userImageView.image else {
            self.showSnackBar(text: "Error: No user image", 
                              image: .systemImage(.warning, color: nil),
                              on: self)
            return
        }
        
        let nextVC = UsernameViewController(firstName: firstName,
                                            lastName: lastNameTextField.text ?? "",
                                            profileImage: image)
        navigate(.next(nextVC, .fullScreen))
    }
}
