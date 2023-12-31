//
//  UsernameVC.swift
//  Messenger
//
//  Created by e1ernal on 31.12.2023.
//

import UIKit

class UsernameVC: UIViewController, UITextFieldDelegate {
    private let emoji: UILabel = {
        let label = UILabel()
        label.text = "💭"
        label.font = Const.Font.large
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = Const.Font.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please create your username"
        label.font = Const.Font.subtitle
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.Constraint.width
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = Const.Constraint.height / 5
        field.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .regular)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .namePhonePad
        field.heightAnchor.constraint(equalToConstant: Const.Constraint.height).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Const.Font.button
        button.backgroundColor = Const.Color.inactive
        button.heightAnchor.constraint(equalToConstant: Const.Constraint.height).isActive = true
        button.layer.cornerRadius = Const.Constraint.height / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.Constraint.height
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func makeUI() {
        view.backgroundColor = Const.Color.primaryBackground
        
        labelsStack.addArrangedSubview(emoji)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)
        
        actionsStack.addArrangedSubview(usernameField)
        actionsStack.addArrangedSubview(continueButton)
        
        view.addSubview(labelsStack)
        view.addSubview(actionsStack)
        
        NSLayoutConstraint.activate([
            actionsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            actionsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: actionsStack.topAnchor, constant: -Const.Constraint.height)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.hasText,
              let username = textField.text else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = Const.Color.inactive
                self.usernameField.layer.borderColor = Const.Color.primaryBackground.cgColor
            }
            return
        }
        
        // Check username avaliability
        Task {
            do {
                try await NetworkService.shared.checkUsername(username: username)
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Const.Color.active
                    self.usernameField.layer.borderColor = Const.Color.completed.cgColor
                }
                print("OK")
            } catch {
                print(error.localizedDescription)
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Const.Color.inactive
                    self.usernameField.layer.borderColor = Const.Color.wrong.cgColor
                }
                print("NOT")
            }
        }
    }
    
    @objc
    func continueButtonTapped() {
        guard continueButton.backgroundColor == Const.Color.active else {
            return
        }
        // Create user
        Task {
            do {
                try await NetworkService.shared.createUser(username: "username", firstname: "Name", lastname: "Lastname", image: UIImage(named: "image")!)
            } catch {
                print(error.localizedDescription)
            }
        }
        // Go to Next VC
    }
}
