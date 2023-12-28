//
//  ProfileInfo.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

class ProfileInfoVC: UIViewController, UITextFieldDelegate {
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Const.Constraint.height * 1.5
        imageView.image = UIImage(named: "image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Info"
        label.font = Const.Font.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your name and add a profile picture"
        label.numberOfLines = 0
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

    private var firstNameField = FloatingTextField(placeholder: "First name (required)")
    private var lastNameField = FloatingTextField(placeholder: "Last name (optional)")

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
        stack.spacing = Const.Constraint.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.delegate = self
        lastNameField.delegate = self

        makeUI()
        hideKeyboardWhenTappedAround()
    }

    private func makeUI() {
        view.backgroundColor = Const.Color.primaryBackground

        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.translatesAutoresizingMaskIntoConstraints = false

        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)

        actionsStack.addArrangedSubview(firstNameField)
        actionsStack.addArrangedSubview(lastNameField)

        view.addSubview(labelsStack)
        view.addSubview(actionsStack)
        view.addSubview(continueButton)
        view.addSubview(profileImage)

        NSLayoutConstraint.activate([
            actionsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            actionsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            labelsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: actionsStack.topAnchor, constant: -Const.Constraint.height),

            continueButton.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: actionsStack.bottomAnchor, constant: Const.Constraint.height),

            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.bottomAnchor.constraint(equalTo: labelsStack.topAnchor, constant: -Const.Constraint.height),
            profileImage.heightAnchor.constraint(equalToConstant: Const.Constraint.height * 3),
            profileImage.widthAnchor.constraint(equalToConstant: Const.Constraint.height * 3)
        ])
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: true)
            if textField === firstNameField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Const.Color.active
                }
            }
        } else {
            guard let floatingTextfield = textField as? FloatingTextField else { return }
            floatingTextfield.changeVisibility(isActive: false)
            if textField === firstNameField {
                UIView.animate(withDuration: 0.25) {
                    self.continueButton.backgroundColor = Const.Color.inactive
                }
            }
        }
    }

    // TODO: Make methods
    @objc
    func imagePickerButtonTapped() {}

    @objc 
    func continueButtonTapped() {}
}
