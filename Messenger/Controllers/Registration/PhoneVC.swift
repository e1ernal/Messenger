//
//  LoginVC.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class PhoneVC: UIViewController, UITextFieldDelegate {
    private let phoneEmoji: UILabel = {
        let label = UILabel()
        label.text = "☎️"
        label.font = Const.Font.large
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Phone"
        label.font = Const.Font.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your phone number"
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

    private lazy var numberField: UITextField = {
        let field = UITextField()
        field.placeholder = "0 000 000 0000"
        field.autocapitalizationType = .none
        field.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .regular)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .numberPad
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

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = numberField.text
        label.font = Const.Font.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this the correct number?"
        label.font = Const.Font.subtitle
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = Const.Font.subtitle
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: Const.Constraint.height).isActive = true
        button.layer.cornerRadius = Const.Constraint.height / 5
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var continueFinalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = Const.Font.button
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: Const.Constraint.height).isActive = true
        button.layer.cornerRadius = Const.Constraint.height / 5
        button.addTarget(self, action: #selector(continueFinalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var checkNumberStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.Constraint.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var alphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.backgroundColor = Const.Color.primaryTransparentBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var popupStackView: UIView = {
        let view = UIView()
        view.backgroundColor = Const.Color.secondaryBackground
        view.layer.cornerRadius = Const.Constraint.width + Const.Constraint.height / 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        hideKeyboardWhenTappedAround()
    }

    private func makeUI() {
        view.backgroundColor = Const.Color.primaryBackground

        labelsStack.addArrangedSubview(phoneEmoji)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)

        actionsStack.addArrangedSubview(numberField)
        actionsStack.addArrangedSubview(continueButton)

        checkNumberStack.addArrangedSubview(numberLabel)
        checkNumberStack.addArrangedSubview(subNumberLabel)
        checkNumberStack.addArrangedSubview(editButton)
        checkNumberStack.addArrangedSubview(continueFinalButton)

        alphaView.addSubview(popupStackView)
        alphaView.addSubview(checkNumberStack)

        view.addSubview(labelsStack)
        view.addSubview(actionsStack)
        view.addSubview(alphaView)

        NSLayoutConstraint.activate([
            actionsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            actionsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            labelsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: actionsStack.topAnchor, constant: -Const.Constraint.height),

            checkNumberStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkNumberStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkNumberStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),

            popupStackView.topAnchor.constraint(equalTo: checkNumberStack.topAnchor, constant: -Const.Constraint.width),
            popupStackView.bottomAnchor.constraint(equalTo: checkNumberStack.bottomAnchor, constant: Const.Constraint.width),
            popupStackView.leadingAnchor.constraint(equalTo: checkNumberStack.leadingAnchor, constant: -Const.Constraint.width),
            popupStackView.trailingAnchor.constraint(equalTo: checkNumberStack.trailingAnchor, constant: Const.Constraint.width),

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
                self.continueButton.backgroundColor = Const.Color.active
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.continueButton.backgroundColor = Const.Color.inactive
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
