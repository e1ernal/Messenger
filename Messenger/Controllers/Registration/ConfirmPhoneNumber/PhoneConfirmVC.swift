//
//  LoginConfirmVC.swift
//  Messenger
//
//  Created by e1ernal on 05.12.2023.
//

import UIKit

class PhoneConfirmViewController: UIViewController {
    internal let digitsCount: Int = 5
    internal var digitLabels = [UILabel]()
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
        .font("We're sent an SMS with an activation code to your phone:\n", .font(.subtitle), .center)
        .font(phoneNumber ?? "undefined", .font(.subtitleBold), .center)
    )
    
    private let digitsStackView = BasicStackView(.horizontal, .const(.spacing), .fillEqually, .fill)
    
    private lazy var digitsTextField: UITextField = {
        let field = UITextField()
        field.tintColor = .clear
        field.textColor = .clear
        field.delegate = self
        field.textContentType = .oneTimeCode
        field.keyboardType = .numberPad
        field.heightAnchor.constraint(equalToConstant: .const(.digitsHeight)).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var helpButton = BasicButton(title: "Haven't received the code?", style: .clear(.active)) {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = false
        }
    }
    
    private let uiStackView = BasicStackView(.vertical, .const(.spacing), nil, nil)
    
    private lazy var helpLabel = BasicLabel(NSMutableAttributedString()
        .font("Sorry", .font(.title), .center)
        .font("\n\nIf you don't get the code by SMS, please check your ", .font(.subtitle), .center)
        .font("cellular data settings", .font(.subtitleBold), .center)
        .font(" and phone number:\n\n", .font(.subtitle), .center)
        .font(phoneNumber ?? "undefined", .font(.subtitleBold), .center)
        .font("\n\nYour remaining option is to try another number", .font(.subtitle), .center)
    )
    
    private lazy var editNumberButton = BasicButton(title: "Edit Number", style: .filled(.active)) {
        self.navigate(.back)
    }
    
    private lazy var closeButton = BasicButton(title: "Close", style: .clear(.active)) {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }
    
    private let helpStackView = BasicStackView(.vertical, .const(.spacing), nil, nil)
    
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
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        showConfirmCode()
    }
    
    private func setupUI() {
        configureVC(title: "", backButton: false)
        
        for _ in 1 ... digitsCount {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.layer.cornerRadius = .const(.cornerRadius)
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
        uiStackView.setCustomSpacing(.const(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(digitsTextField)
        uiStackView.setCustomSpacing(.const(.doubleSpacing), after: digitsTextField)
        uiStackView.addArrangedSubview(helpButton)
        
        popupView.layer.cornerRadius = .const(.spacing) + .const(.cornerRadius)
        
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
            
            popupView.topAnchor.constraint(equalTo: helpStackView.topAnchor, constant: -.const(.spacing)),
            popupView.bottomAnchor.constraint(equalTo: helpStackView.bottomAnchor, constant: .const(.spacing)),
            popupView.leadingAnchor.constraint(equalTo: helpStackView.leadingAnchor, constant: -.const(.spacing)),
            popupView.trailingAnchor.constraint(equalTo: helpStackView.trailingAnchor, constant: .const(.spacing)),
            
            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        alphaView.isHidden = true
    }
    
    private func showConfirmCode() {
        Print.info(screen: self, action: #function, reason: ["Code": code ?? "-"], show: true)
    }
}
