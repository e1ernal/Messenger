//
//  UsernameVC.swift
//  Messenger
//
//  Created by e1ernal on 31.12.2023.
//

import UIKit

class UsernameViewController: UIViewController {
    private var firstName: String
    private var lastName: String
    private var profileImage: UIImage
    internal var isUsernameAvailable = false
    
    private let emojiLabel = BasicLabel("💭", .font(.large))
    private let titleLabel = BasicLabel("Username", .font(.title))
    private let subtitleLabel = BasicLabel("Please create your username", .font(.subtitle))
    
    internal lazy var usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.autocapitalizationType = .none
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = .const(.cornerRadius)
        field.font = .font(.textField)
        field.autocorrectionType = .no
        field.delegate = self
        field.textAlignment = .center
        field.keyboardType = .namePhonePad
        field.heightAnchor.constraint(equalToConstant: .const(.height)).isActive = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    internal lazy var continueButton = BasicButton(title: "Continue", style: .filled(.inactive)) {
        self.continueButtonTapped()
    }
    
    private let uiStackView = BasicStackView(.vertical, .const(.spacing), nil, nil)
    
    // MARK: - Init UIViewController
    init(firstName: String, lastName: String, profileImage: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        configureVC(title: "", backButton: false)
        
        uiStackView.addArrangedSubview(emojiLabel)
        uiStackView.addArrangedSubview(titleLabel)
        uiStackView.addArrangedSubview(subtitleLabel)
        uiStackView.setCustomSpacing(.const(.doubleSpacing), after: subtitleLabel)
        uiStackView.addArrangedSubview(usernameTextField)
        uiStackView.setCustomSpacing(.const(.doubleSpacing), after: usernameTextField)
        uiStackView.addArrangedSubview(continueButton)
        
        view.addSubview(uiStackView)
        
        NSLayoutConstraint.activate([
            uiStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3),
            uiStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc func continueButtonTapped() {
        guard isUsernameAvailable else { return }
        
        guard let username = usernameTextField.text else {
            self.showSnackBar(text: "Error: Username is empty", 
                              image: .systemImage(.warning, color: nil),
                              on: self)
            return
        }
        
        Task {
            do {
                let token = try await NetworkService.shared.createUser(username: username,
                                                                       firstname: firstName,
                                                                       lastname: lastName,
                                                                       image: profileImage)
                
                try Storage.shared.save(token, as: .token, in: .account)
                let nextVC = LaunchScreenVC(greeting: "Welcome")
                self.navigate(.root(nextVC))
            } catch {
                print(error.localizedDescription)
                self.showSnackBar(text: "Error: Can't create user", 
                                  image: .systemImage(.warning, color: nil),
                                  on: self)
            }
        }
    }
}
