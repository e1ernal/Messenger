//
//  LoginVC.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class PhoneVC: UIViewController, UITextFieldDelegate {
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "☎️"
        label.font = .font(.large)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Phone"
        label.font = .font(.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your phone number"
        label.font = .font(.subtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var numberTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "+0 000 000 0000"
        field.autocapitalizationType = .none
        field.font = .font(.textField)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .numberPad
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

    private lazy var numberStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = numberTextField.text
        label.font = .font(.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this the correct number?"
        label.font = .font(.subtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .font(.button)
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var continueFinalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .font(.button)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(continueFinalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let checkNumberStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .color(.transparentBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .color(.secondaryBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        popupView.layer.cornerRadius = .constant(.spacing) + .constant(.cornerRadius)
        continueFinalButton.heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        continueFinalButton.layer.cornerRadius = .constant(.cornerRadius)
        
        numberStackView.addArrangedSubview(emojiLabel)
        numberStackView.addArrangedSubview(titleLabel)
        numberStackView.addArrangedSubview(subtitleLabel)
        numberStackView.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        numberStackView.addArrangedSubview(numberTextField)
        numberStackView.setCustomSpacing(.constant(.doubleSpacing), after: numberTextField)
        numberStackView.addArrangedSubview(continueButton)
        
        checkNumberStackView.addArrangedSubview(numberLabel)
        checkNumberStackView.addArrangedSubview(questionLabel)
        checkNumberStackView.setCustomSpacing(.constant(.doubleSpacing), after: questionLabel)
        checkNumberStackView.addArrangedSubview(editButton)
        checkNumberStackView.addArrangedSubview(continueFinalButton)
        
        alphaView.addSubview(popupView)
        alphaView.addSubview(checkNumberStackView)

        view.addSubview(numberStackView)
        view.addSubview(alphaView)

        NSLayoutConstraint.activate([
            numberStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            numberStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            checkNumberStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkNumberStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            checkNumberStackView.topAnchor.constraint(equalTo: numberTextField.topAnchor),

            popupView.topAnchor.constraint(equalTo: checkNumberStackView.topAnchor, constant: -.constant(.spacing)),
            popupView.bottomAnchor.constraint(equalTo: checkNumberStackView.bottomAnchor, constant: .constant(.spacing)),
            popupView.leadingAnchor.constraint(equalTo: checkNumberStackView.leadingAnchor, constant: -.constant(.spacing)),
            popupView.trailingAnchor.constraint(equalTo: checkNumberStackView.trailingAnchor, constant: .constant(.spacing)),
            
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
                self.continueButton.backgroundColor = .color(.active)
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = .color(.inactive)
            }
        }
    }

    @objc 
    func continueButtonTapped() {
        if numberTextField.hasText {
            UIView.animate(withDuration: 0.25) {
                self.numberLabel.text = self.numberTextField.text
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
                let code = try await NetworkService.shared.getVerificationCode(phoneNumber: number)

                let nextVC = PhoneConfirmVC(phoneNumber: text, code: code)
                showNextVC(nextVC: nextVC)
            } catch let error as NetworkError {
                print(error.description)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @objc 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = numberTextField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        numberTextField.text = formatter(mask: "+X (XXX) XXX-XXXX", phoneNumber: newString)
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
