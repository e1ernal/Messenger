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

    private let codeEmoji: UILabel = {
        let label = UILabel()
        label.text = "💬"
        label.font = Const.Font.large
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Code"
        label.font = Const.Font.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "We're sent an SMS with an acvivation code to your phone"
        label.numberOfLines = 0
        label.font = Const.Font.subtitle
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.Constraint.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var digitsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = Const.Constraint.spacing
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
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        hideKeyboardWhenTappedAround()
    }

    private func makeUI() {
        view.backgroundColor = Const.Color.primaryBackground
        
        for _ in 1 ... digitsCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.layer.cornerRadius = Const.Constraint.height / 5
            label.layer.borderWidth = 1.0
            label.layer.borderColor = Const.Color.inactive.cgColor
            label.font = .systemFont(ofSize: 25)
            label.isUserInteractionEnabled = true

            digitsStack.addArrangedSubview(label)
            digitLabels.append(label)
        }

        labelsStack.addArrangedSubview(codeEmoji)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)

        view.addSubview(labelsStack)
        view.addSubview(digitsStack)
        view.addSubview(digitsField)

        NSLayoutConstraint.activate([
            digitsField.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            digitsField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            digitsField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitsField.heightAnchor.constraint(equalToConstant: Const.Constraint.height * 4 / 3),

            digitsStack.topAnchor.constraint(equalTo: digitsField.topAnchor),
            digitsStack.leadingAnchor.constraint(equalTo: digitsField.leadingAnchor),
            digitsStack.trailingAnchor.constraint(equalTo: digitsField.trailingAnchor),
            digitsStack.bottomAnchor.constraint(equalTo: digitsField.bottomAnchor),

            labelsStack.bottomAnchor.constraint(equalTo: digitsStack.topAnchor, constant: -Const.Constraint.height),
            labelsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count <= digitsCount else { return }

        for digitIndex in 0 ..< digitsCount {
            let currentLabel = digitLabels[digitIndex]

            if digitIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: digitIndex)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderColor = Const.Color.active.cgColor
            } else {
                currentLabel.text?.removeAll()
                currentLabel.layer.borderColor = Const.Color.inactive.cgColor
            }
        }

        if text.count == digitsCount {
            Task {
                do {
                    try await NetworkService.shared.confirmVerificationCode(code: text)
                    for label in digitLabels {
                        label.layer.borderColor = Const.Color.completed.cgColor
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showNextVC(nextVC: ProfileInfoVC())
                    }
                } catch let error as NetworkError {
                    print(error.description)
                    for label in digitLabels {
                        label.layer.borderColor = Const.Color.wrong.cgColor
                    }
                } catch {
                    print(error.localizedDescription)
                    for label in digitLabels {
                        label.layer.borderColor = Const.Color.wrong.cgColor
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
