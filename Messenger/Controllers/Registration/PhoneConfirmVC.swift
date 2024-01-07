//
//  LoginConfirmVC.swift
//  Messenger
//
//  Created by e1ernal on 05.12.2023.
//

import UIKit

class PhoneConfirmVC: UIViewController, UITextFieldDelegate {
    private let digitsCount: Int = 5
    private var digitLabels = [UILabel]()
    private var phoneNumber: String?
    private var code: String?
    
    convenience init(phoneNumber: String, code: String) {
        self.init()
        self.phoneNumber = phoneNumber
        self.code = code
    }
    
    private let emojiLabel = BasicLabel("💬", .font(.large))
    private let titleLabel = BasicLabel("Enter Code", .font(.title))
    private lazy var subtitleLabel = BasicLabel(NSMutableAttributedString()
        .font("We're sent an SMS with an activation code to your phone:\n", .font(.subtitle))
        .font(phoneNumber ?? "undefined", .font(.subtitleBold))
    )
    
    private lazy var digitsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var digitsTextField: UITextField = {
        let field = UITextField()
        field.tintColor = .clear
        field.textColor = .clear
        field.delegate = self
        field.textContentType = .oneTimeCode
        field.keyboardType = .numberPad
        field.heightAnchor.constraint(equalToConstant: .constant(.digitsHeight)).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var helpButton = BasicButton(title: "Haven't received the code?", style: .clear(.active)) {
        self.helpButtonTapped()
    }
    
    private lazy var uiStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var helpLabel = BasicLabel(NSMutableAttributedString()
        .font("Sorry", .font(.title))
        .font("\n\nIf you don't get the code by SMS, please check your ", .font(.subtitle))
        .font("cellular data settings", .font(.subtitleBold))
        .font(" and phone number:\n\n", .font(.subtitle))
        .font(phoneNumber ?? "undefined", .font(.subtitleBold))
        .font("\n\nYour remaining option is to try another number", .font(.subtitle))
    )
    
    private lazy var editNumberButton = BasicButton(title: "Edit Number", style: .filled(.active)) {
        self.editNumberButtonTapped()
    }
    
    private lazy var closeButton = BasicButton(title: "Close", style: .clear(.active)) {
        self.closeButtonTapped()
    }
    
    private let helpStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .constant(.spacing)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .color(.secondaryBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .color(.transparentBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let alert = UIAlertController(title: "Alert", message: "Your code: " + (code ?? "no code"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        setupVC(title: "", backButton: false)
        
        for _ in 1 ... digitsCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.layer.cornerRadius = .constant(.cornerRadius)
            label.layer.borderWidth = 1.0
            label.layer.borderColor = .color(.inactive)
            label.font = .font(.codeField)
            
            digitsStackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        digitsStackView.isUserInteractionEnabled = false
        
        uiStackView.addArrangedSubview(emojiLabel)
        uiStackView.addArrangedSubview(titleLabel)
        uiStackView.addArrangedSubview(subtitleLabel)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(digitsTextField)
        uiStackView.setCustomSpacing(.constant(.doubleSpacing), after: digitsTextField)
        uiStackView.addArrangedSubview(helpButton)
        
        popupView.layer.cornerRadius = .constant(.spacing) + .constant(.cornerRadius)
        
        helpStackView.addArrangedSubview(helpLabel)
        helpStackView.addArrangedSubview(closeButton)
        helpStackView.addArrangedSubview(editNumberButton)
        
        alphaView.addSubview(popupView)
        alphaView.addSubview(helpStackView)
        
        view.addSubview(uiStackView)
        view.addSubview(digitsStackView)
        view.addSubview(alphaView)
        
        NSLayoutConstraint.activate([
            uiStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            digitsStackView.topAnchor.constraint(equalTo: digitsTextField.topAnchor),
            digitsStackView.leadingAnchor.constraint(equalTo: digitsTextField.leadingAnchor),
            digitsStackView.trailingAnchor.constraint(equalTo: digitsTextField.trailingAnchor),
            digitsStackView.bottomAnchor.constraint(equalTo: digitsTextField.bottomAnchor),
            
            helpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helpStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            helpStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            
            popupView.topAnchor.constraint(equalTo: helpStackView.topAnchor, constant: -.constant(.spacing)),
            popupView.bottomAnchor.constraint(equalTo: helpStackView.bottomAnchor, constant: .constant(.spacing)),
            popupView.leadingAnchor.constraint(equalTo: helpStackView.leadingAnchor, constant: -.constant(.spacing)),
            popupView.trailingAnchor.constraint(equalTo: helpStackView.trailingAnchor, constant: .constant(.spacing)),
            
            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        alphaView.isHidden = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count <= digitsCount else { return }
        
        for digitIndex in 0 ..< digitsCount {
            let currentLabel = digitLabels[digitIndex]
            
            if digitIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: digitIndex)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderColor = .color(.active)
            } else {
                currentLabel.text?.removeAll()
                currentLabel.layer.borderColor = .color(.inactive)
            }
        }
        
        if text.count == digitsCount {
            Task {
                do {
                    try await NetworkService.shared.confirmVerificationCode(code: text)
                    for label in digitLabels {
                        label.layer.borderColor = .color(.success)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showNextVC(nextVC: ProfileInfoVC())
                    }
                } catch let error as NetworkError {
                    print(error.description)
                    for label in digitLabels {
                        label.layer.borderColor = .color(.failure)
                    }
                } catch {
                    print(error.localizedDescription)
                    for label in digitLabels {
                        label.layer.borderColor = .color(.failure)
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitsCount || string.isEmpty
    }
    
    @objc
    func helpButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = false
        }
    }
    
    @objc
    func editNumberButtonTapped() {
        popBackVC()
    }
    
    @objc
    func closeButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }
}
