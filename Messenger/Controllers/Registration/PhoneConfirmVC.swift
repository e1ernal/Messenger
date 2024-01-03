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
    var phoneNumber: String?
    var code: String?
    
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
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString()
            .font("We're sent an SMS with an activation code to your phone: ", font: Font.subtitle.font)
            .font(phoneNumber ?? "undefined", font: Font.subtitleBold.font)
        label.numberOfLines = 0
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
    
    private lazy var noCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Haven't received the code?", for: .normal)
        button.titleLabel?.font = Font.subtitle.font
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(noCodeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var uiStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var noCodeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString()
            .font("Sorry", font: Font.title.font)
            .font("\n\nIf you don't get the code by SMS, please check your ", font: Font.subtitle.font)
            .font("cellular data settings", font: Font.subtitleBold.font)
            .font(" and phone number:\n\n", font: Font.subtitle.font)
            .font(phoneNumber ?? "undefined", font: Font.subtitleBold.font)
            .font("\n\nYour remaining option is to try another number", font: Font.subtitle.font)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noCodeGoBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Number", for: .normal)
        button.titleLabel?.font = Font.button.font
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: Constraint.height.rawValue).isActive = true
        button.layer.cornerRadius = Constraint.height.rawValue / 5
        button.addTarget(self, action: #selector(noCodeGoBackButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = Font.subtitle.font
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noCodeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constraint.spacing.rawValue
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.secondaryBackground.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.transparentBackground.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        hideKeyboardWhenTappedAround()
        
        let alert = UIAlertController(title: "Alert", message: "Your code: \(code ?? "no code")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        uiStack.addArrangedSubview(emoji)
        uiStack.addArrangedSubview(titleLabel)
        uiStack.addArrangedSubview(subtitleLabel)
        uiStack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: subtitleLabel)
        uiStack.addArrangedSubview(digitsField)
        uiStack.setCustomSpacing(Constraint.doubleSpacing.rawValue, after: digitsField)
        uiStack.addArrangedSubview(noCodeButton)
        
        popupView.layer.cornerRadius = Constraint.spacing.rawValue + Constraint.height.rawValue / 5
        
        noCodeStack.addArrangedSubview(noCodeLabel)
        noCodeStack.addArrangedSubview(closeButton)
        noCodeStack.addArrangedSubview(noCodeGoBackButton)
        
        alphaView.addSubview(popupView)
        alphaView.addSubview(noCodeStack)
        
        view.addSubview(uiStack)
        view.addSubview(digitsStack)
        view.addSubview(alphaView)
        
        NSLayoutConstraint.activate([
            uiStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            digitsStack.topAnchor.constraint(equalTo: digitsField.topAnchor),
            digitsStack.leadingAnchor.constraint(equalTo: digitsField.leadingAnchor),
            digitsStack.trailingAnchor.constraint(equalTo: digitsField.trailingAnchor),
            digitsStack.bottomAnchor.constraint(equalTo: digitsField.bottomAnchor),
            
            noCodeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCodeStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noCodeStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),

            popupView.topAnchor.constraint(equalTo: noCodeStack.topAnchor, constant: -Constraint.spacing.rawValue),
            popupView.bottomAnchor.constraint(equalTo: noCodeStack.bottomAnchor, constant: Constraint.spacing.rawValue),
            popupView.leadingAnchor.constraint(equalTo: noCodeStack.leadingAnchor, constant: -Constraint.spacing.rawValue),
            popupView.trailingAnchor.constraint(equalTo: noCodeStack.trailingAnchor, constant: Constraint.spacing.rawValue),
            
            popupView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitsCount || string.isEmpty
    }
    
    @objc
    func noCodeButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = false
        }
    }
    
    @objc
    func noCodeGoBackButtonTapped() {
        popBackVC()
    }
    
    @objc
    func closeButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }
}
