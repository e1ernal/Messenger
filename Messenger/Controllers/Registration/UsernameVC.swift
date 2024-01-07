//
//  UsernameVC.swift
//  Messenger
//
//  Created by e1ernal on 31.12.2023.
//

import UIKit

class UsernameVC: UIViewController, UITextFieldDelegate {
    private var firstName: String?
    private var lastName: String?
    private var profileImage: UIImage?
    private var isUsernameAvailable: Bool = false
    
    convenience init(firstName: String, lastName: String?, profileImage: UIImage) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
    }
    
    private let emojiLabel = BasicLabel("💭", .font(.large))
    private let titleLabel = BasicLabel("Username", .font(.title))
    private let subtitleLabel = BasicLabel("Please create your username", .font(.subtitle))
    
    private lazy var usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = .constant(.cornerRadius)
        field.font = .font(.textField)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .namePhonePad
        field.heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var continueButton = BasicButton(title: "Continue", style: .filled(.inactive)) {
        self.continueButtonTapped()
    }
    
    private lazy var uiStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        uiStackView.addArrangedSubview(emojiLabel)
        uiStackView.addArrangedSubview(titleLabel)
        uiStackView.addArrangedSubview(subtitleLabel)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(usernameTextField)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: usernameTextField)
        uiStackView.addArrangedSubview(continueButton)
        
        view.addSubview(uiStackView)
        
        NSLayoutConstraint.activate([
            uiStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText,
              let username = textField.text else {
            continueButton.setState(.inactive)
            UIView.animate(withDuration: 0.25) {
                self.usernameTextField.layer.borderColor = .color(.background)
            }
            return
        }
        
        // Check username availability
        Task {
            do {
                try await NetworkService.shared.checkUsername(username)
                isUsernameAvailable = true
            } catch {
                print(error.localizedDescription)
                isUsernameAvailable = false
            }
            let buttonState: ViewState = isUsernameAvailable ? .active : .inactive
            let fieldColor: CGColor = isUsernameAvailable ? .color(.success) : .color(.failure)
            
            UIView.animate(withDuration: 0.25) {
                self.usernameTextField.layer.borderColor = fieldColor
            }
            continueButton.setState(buttonState)
        }
    }
    
    @objc
    func continueButtonTapped() {
        guard isUsernameAvailable else {
            print("Username isn't available")
            return
        }
        
        guard let firstName,
              let username = usernameTextField.text,
              let profileImage else {
            print("Some user data doesn't exist")
            return
        }
        
        Task {
            do {
                try await NetworkService.shared.createUser(username: username,
                                                           firstname: firstName,
                                                           lastname: lastName,
                                                           image: profileImage)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
