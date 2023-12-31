//
//  UsernameVC.swift
//  Messenger
//
//  Created by e1ernal on 31.12.2023.
//

import UIKit

class UsernameVC: UIViewController, UITextFieldDelegate {
    var firstName: String?
    var lastName: String?
    var profileImage: UIImage?
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.text = "💭"
        label.font = Font.large.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please create your username"
        label.font = Font.subtitle.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = Constraint.height.rawValue / 5
        field.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .regular)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .namePhonePad
        field.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = Color.inactive.color
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func makeUI() {
        view.backgroundColor = Color.background.color
        navigationItem.setHidesBackButton(true, animated: true)
        
        stack.addArrangedSubview(emoji)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: subtitleLabel)
        stack.addArrangedSubview(usernameField)
        stack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: usernameField)
        stack.addArrangedSubview(continueButton)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText,
              let username = textField.text else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = Color.inactive.color
                self.usernameField.layer.borderColor = Color.background.color.cgColor
            }
            return
        }
        
        // Check username avaliability
        Task {
            do {
                try await NetworkService.shared.checkUsername(username: username)
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Color.active.color
                    self.usernameField.layer.borderColor = Color.success.color.cgColor
                }
                print("OK")
            } catch {
                print(error.localizedDescription)
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Color.inactive.color
                    self.usernameField.layer.borderColor = Color.noSuccess.color.cgColor
                }
                print("NOT")
            }
        }
    }
    
    @objc
    func continueButtonTapped() {
        print("Username: \(String(describing: usernameField.text))")
        print("First name: \(String(describing: firstName))")
        print("Last name: \(String(describing: lastName))")
        print("Image: \(String(describing: profileImage))")
        
        guard continueButton.backgroundColor == Color.active.color,
              let firstName,
              let username = usernameField.text,
              let profileImage else {
            print("Some problem")
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
