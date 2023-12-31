//
//  LoginConfirmVC.swift
//  Messenger
//
//  Created by e1ernal on 05.12.2023.
//

import UIKit

class PhoneConvirmVC: UIViewController, UITextFieldDelegate {
    private let digitsCount: Int = 5
    private var digitLabels = [UILabel]()

    private let emoji: UILabel = {
        let label = UILabel()
        label.text = "💬"
        label.font = Font.large.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Code"
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "We're sent an SMS with an acvivation code to your phone"
        label.numberOfLines = 0
        label.font = Font.subtitle.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var digitsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var digitsField: UITextField = {
        let field = UITextField()
        field.tintColor = .clear
        field.textColor = .clear
        field.delegate = self
        field.textContentType = .oneTimeCode
        field.keyboardType = .numberPad
        field.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue * 4 / 3).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
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
        
        for _ in 1 ... digitsCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.layer.cornerRadius = Constraint.height.rawValue / 5
            label.layer.borderWidth = 1.0
            label.layer.borderColor = Color.inactive.color.cgColor
            label.font = .systemFont(ofSize: 25)

            digitsStack.addArrangedSubview(label)
            digitLabels.append(label)
        }
        digitsStack.isUserInteractionEnabled = false
        
        stack.addArrangedSubview(emoji)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: subtitleLabel)
        stack.addArrangedSubview(digitsField)

        view.addSubview(stack)
        view.addSubview(digitsStack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            digitsStack.topAnchor.constraint(equalTo: digitsField.topAnchor),
            digitsStack.leadingAnchor.constraint(equalTo: digitsField.leadingAnchor),
            digitsStack.trailingAnchor.constraint(equalTo: digitsField.trailingAnchor),
            digitsStack.bottomAnchor.constraint(equalTo: digitsField.bottomAnchor)
        ])
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count <= digitsCount else { return }

        for digitIndex in 0 ..< digitsCount {
            let currentLabel = digitLabels[digitIndex]

            if digitIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: digitIndex)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderColor = Color.active.color.cgColor
            } else {
                currentLabel.text?.removeAll()
                currentLabel.layer.borderColor = Color.inactive.color.cgColor
            }
        }

        if text.count == digitsCount {
            Task {
                do {
                    try await NetworkService.shared.confirmVerificationCode(code: text)
                    for label in digitLabels {
                        label.layer.borderColor = Color.success.color.cgColor
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showNextVC(nextVC: ProfileInfoVC())
                    }
                } catch let error as NetworkError {
                    print(error.description)
                    for label in digitLabels {
                        label.layer.borderColor = Color.noSuccess.color.cgColor
                    }
                } catch {
                    print(error.localizedDescription)
                    for label in digitLabels {
                        label.layer.borderColor = Color.noSuccess.color .cgColor
                    }
                }
            }
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let caracterCount = textField.text?.count else { return false }
        return caracterCount < digitsCount || string.isEmpty
    }
}
