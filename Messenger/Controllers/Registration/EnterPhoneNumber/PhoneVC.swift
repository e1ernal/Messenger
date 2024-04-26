//
//  LoginVC.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class PhoneViewController: UIViewController {
    private let emojiLabel = BasicLabel("☎️", .font(.large))
    private let titleLabel = BasicLabel("Your Phone", .font(.title))
    private let subtitleLabel = BasicLabel("Please enter your phone number", .font(.subtitle))
    
    internal lazy var numberTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "+0 000 000 0000"
        field.autocapitalizationType = .none
        field.font = .font(.textField)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.heightAnchor.constraint(equalToConstant: .const(.height)).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    internal lazy var continueButton = BasicButton(title: "Continue", style: .filled(.inactive)) {
        if self.numberTextField.hasText {
            self.numberLabel.text = self.numberTextField.text
            UIView.animate(withDuration: 0.25) {
                self.alphaView.isHidden = false
            }
        }
    }
    
    private let numberStackView = BasicStackView(.vertical, .const(.spacing), nil, nil)
    private let numberLabel = BasicLabel("", .font(.title))
    private let questionLabel = BasicLabel("Is this the correct number?", .font(.subtitle))
    
    private lazy var editButton = BasicButton(title: "Edit", style: .clear(.active)) {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }
    
    private lazy var continueFinalButton = BasicButton(title: "Continue", style: .filled(.active)) {
        self.continueFinalButtonTapped()
    }
    
    private let checkNumberStackView = BasicStackView(.vertical, .const(.spacing), nil, nil)
    
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
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureVC(title: "", backButton: false)
        
        popupView.layer.cornerRadius = .const(.spacing) + .const(.cornerRadius)
        continueFinalButton.heightAnchor.constraint(equalToConstant: .const(.height)).isActive = true
        continueFinalButton.layer.cornerRadius = .const(.cornerRadius)
        
        numberStackView.addArrangedSubview(emojiLabel)
        numberStackView.addArrangedSubview(titleLabel)
        numberStackView.addArrangedSubview(subtitleLabel)
        numberStackView.setCustomSpacing(.const(.doubleSpacing), after: subtitleLabel)
        numberStackView.addArrangedSubview(numberTextField)
        numberStackView.setCustomSpacing(.const(.doubleSpacing), after: numberTextField)
        numberStackView.addArrangedSubview(continueButton)
        
        checkNumberStackView.addArrangedSubview(numberLabel)
        checkNumberStackView.addArrangedSubview(questionLabel)
        checkNumberStackView.setCustomSpacing(.const(.doubleSpacing), after: questionLabel)
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
            
            popupView.topAnchor.constraint(equalTo: checkNumberStackView.topAnchor, constant: -.const(.spacing)),
            popupView.bottomAnchor.constraint(equalTo: checkNumberStackView.bottomAnchor, constant: .const(.spacing)),
            popupView.leadingAnchor.constraint(equalTo: checkNumberStackView.leadingAnchor, constant: -.const(.spacing)),
            popupView.trailingAnchor.constraint(equalTo: checkNumberStackView.trailingAnchor, constant: .const(.spacing)),
            
            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        alphaView.isHidden = true
    }
    
    // MARK: - Actions
    @objc func continueFinalButtonTapped() {
        Task {
            do {
                guard let text = numberLabel.text else {
                    throw DescriptionError.error("Phone number is empty")
                }
                
                let number = text.filter { digit in "+0123456789".contains(digit) }
                guard number.count == 12 else {
                    throw DescriptionError.error("Invalid count of numbers")
                }
                
                let code = try await NetworkService.shared.getVerificationCode(phoneNumber: number)
                
                let nextVC = PhoneConfirmViewController(phoneNumber: text, code: code)
                navigate(.next(nextVC, .fullScreen))
            } catch {
                self.showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
            }
        }
    }
}
