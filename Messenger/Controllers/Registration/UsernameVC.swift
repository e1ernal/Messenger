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
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.text = "💭"
        label.font = .font(.large)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .font(.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please create your username"
        label.font = .font(.subtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameField: UITextField = {
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
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .font(.button)
        button.backgroundColor = .color(.inactive)
        button.heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        button.layer.cornerRadius = .constant(.cornerRadius)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var uiStack: UIStackView = {
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
        
        uiStack.addArrangedSubview(emoji)
        uiStack.addArrangedSubview(titleLabel)
        uiStack.addArrangedSubview(subtitleLabel)
        uiStack.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        uiStack.addArrangedSubview(usernameField)
        uiStack.setCustomSpacing(.constant(.doubleSpacing), after: usernameField)
        uiStack.addArrangedSubview(continueButton)
        
        view.addSubview(uiStack)
        
        NSLayoutConstraint.activate([
            uiStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText,
              let username = textField.text else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = .color(.inactive)
                self.usernameField.layer.borderColor = .color(.background)
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
            let buttonColor: UIColor = isUsernameAvailable ? .color(.active) : .color(.inactive)
            let fieldColor: CGColor = isUsernameAvailable ? .color(.success) : .color(.failure)
            
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = buttonColor
                self.usernameField.layer.borderColor = fieldColor
            }
        }
    }
    
    @objc
    func continueButtonTapped() {
        guard isUsernameAvailable else {
            print("Username isn't available")
            return
        }
        
        guard let firstName,
              let username = usernameField.text,
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
