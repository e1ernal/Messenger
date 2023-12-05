//
//  LoginVC.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    let heightConstraint: CGFloat = 40.0
    let widthConstraint: CGFloat = 10.0
    var buttonColor: UIColor = .systemGray
    var buttonAlpha: Double = 0.5
    
    private let phoneEmoji: UILabel = {
        let label = UILabel()
        label.text = "☎️"
        label.font = UIFont.systemFont(ofSize: CGFloat(70), weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Phone"
        label.font = UIFont.systemFont(ofSize: CGFloat(25), weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your phone number"
        label.font = UIFont.systemFont(ofSize: CGFloat(15), weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = widthConstraint
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
        field.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = buttonColor
        button.alpha = buttonAlpha
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = heightConstraint
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = numberField.text
        label.font = UIFont.systemFont(ofSize: CGFloat(25), weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this the correct number?"
        label.font = UIFont.systemFont(ofSize: CGFloat(15), weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var continueFinalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        button.layer.cornerRadius = heightConstraint / 5
        button.addTarget(self, action: #selector(continueFinalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var checkNumberStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var alphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var popupStackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = widthConstraint + heightConstraint / 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func makeUI() {
        view.backgroundColor = .systemBackground
        
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
            actionsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2/3),
            actionsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelsStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2/3),
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: actionsStack.topAnchor, constant: -heightConstraint),
            
            checkNumberStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkNumberStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkNumberStack.widthAnchor.constraint(equalToConstant: view.frame.width * 2/3),
            
            popupStackView.topAnchor.constraint(equalTo: checkNumberStack.topAnchor, constant: -widthConstraint),
            popupStackView.bottomAnchor.constraint(equalTo: checkNumberStack.bottomAnchor, constant: widthConstraint),
            popupStackView.leadingAnchor.constraint(equalTo: checkNumberStack.leadingAnchor, constant: -widthConstraint),
            popupStackView.trailingAnchor.constraint(equalTo: checkNumberStack.trailingAnchor, constant: widthConstraint),
            
            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        alphaView.isHidden = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            buttonColor = .systemBlue
            buttonAlpha = 1.0
        } else {
            buttonColor = .systemGray
            buttonAlpha = 0.5
        }
        UIView.animate(withDuration: 0.25) {
            self.continueButton.backgroundColor = self.buttonColor
            self.continueButton.alpha = self.buttonAlpha
        }
    }
    
    @objc func continueButtonTapped() {
        if numberField.hasText {
            UIView.animate(withDuration: 0.25) {
                self.numberLabel.text = self.numberField.text
                self.alphaView.isHidden = false
            }
        }
    }
    
    @objc func editButtonTapped() {
        UIView.animate(withDuration: 0.25) {
            self.alphaView.isHidden = true
        }
    }
    
    @objc func continueFinalButtonTapped() {
        print("Go to the next VC!")
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
