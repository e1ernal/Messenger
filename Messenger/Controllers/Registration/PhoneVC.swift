//
//  LoginVC.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class PhoneVC: UIViewController, UITextFieldDelegate {
    private let emoji: UILabel = {
        let label = UILabel()
        label.text = "☎️"
        label.font = Font.large.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Phone"
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your phone number"
        label.font = Font.subtitle.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var numberField: UITextField = {
        let field = UITextField()
        field.placeholder = "+0 000 000 0000"
        field.autocapitalizationType = .none
        field.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .regular)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .numberPad
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

    private lazy var enterNumberStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = numberField.text
        label.font = Font.title.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this the correct number?"
        label.font = Font.subtitle.font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = Font.subtitle.font
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var continueFinalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(continueFinalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var checkNumberStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.transparentBackground.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var popupStackView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.secondaryBackground.color
        view.layer.cornerRadius = Constraint.spacing.rawValue + Constraint.height.rawValue / 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        hideKeyboardWhenTappedAround()
    }

    private func makeUI() {
        view.backgroundColor = Color.background.color
        navigationItem.setHidesBackButton(true, animated: true)
        
        enterNumberStack.addArrangedSubview(emoji)
        enterNumberStack.addArrangedSubview(titleLabel)
        enterNumberStack.addArrangedSubview(subtitleLabel)
        enterNumberStack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: subtitleLabel)
        enterNumberStack.addArrangedSubview(numberField)
        enterNumberStack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: numberField)
        enterNumberStack.addArrangedSubview(continueButton)
        
        checkNumberStack.addArrangedSubview(numberLabel)
        checkNumberStack.addArrangedSubview(subNumberLabel)
        checkNumberStack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: subNumberLabel)
        checkNumberStack.addArrangedSubview(editButton)
        checkNumberStack.addArrangedSubview(continueFinalButton)

        alphaView.addSubview(popupStackView)
        alphaView.addSubview(checkNumberStack)

        view.addSubview(enterNumberStack)
        view.addSubview(alphaView)

        NSLayoutConstraint.activate([
            enterNumberStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            enterNumberStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNumberStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            checkNumberStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkNumberStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            checkNumberStack.topAnchor.constraint(equalTo: numberField.topAnchor),

            popupStackView.topAnchor.constraint(equalTo: checkNumberStack.topAnchor, constant: -Constraint.spacing.rawValue),
            popupStackView.bottomAnchor.constraint(equalTo: checkNumberStack.bottomAnchor, constant: Constraint.spacing.rawValue),
            popupStackView.leadingAnchor.constraint(equalTo: checkNumberStack.leadingAnchor, constant: -Constraint.spacing.rawValue),
            popupStackView.trailingAnchor.constraint(equalTo: checkNumberStack.trailingAnchor, constant: Constraint.spacing.rawValue),

            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        alphaView.isHidden = true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = Color.active.color
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = Color.inactive.color
            }
        }
    }

    @objc 
    func continueButtonTapped() {
        if numberField.hasText {
            UIView.animate(withDuration: 0.25) {
                self.numberLabel.text = self.numberField.text
                self.alphaView.isHidden = false
            }
        }
    }

    @objc 
    func editButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }

    @objc 
    func continueFinalButtonTapped() {
        guard let text = numberLabel.text else {
            print("Error: Phone number is empty")
            // TODO: - добавить сюда алерт
            return
        }

        let number = text.filter { digit in
            "+0123456789".contains(digit)
        }
        
        guard number.count == 12 else {
            print("Error: Invalid count of numbers")
            // TODO: - добавить сюда алерт
            return
        }
        Task {
            do {
                try await NetworkService.shared.getVerificationCode(phoneNumber: number)
                showNextVC(nextVC: PhoneConvirmVC())
            } catch let error as NetworkError {
                print(error.description)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @objc 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = numberField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        numberField.text = formatter(mask: "+X (XXX) XXX-XXXX", phoneNumber: newString)
        return false
    }

    func formatter(mask: String, phoneNumber: String) -> String {
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result: String = ""
        var index = number.startIndex
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}
