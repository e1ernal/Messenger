//
//  LaunchScreenVC.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

enum LoadingIndicator {
    case start
    case stop
}

class LaunchScreenVC: UIViewController {
    private let greeting: String
    private let nameLabel = BasicLabel("", .font(.appName))
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    // MARK: - Init UITabBarController
    init(greeting: String) {
        self.greeting = greeting
        nameLabel.text = greeting
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .constant(.spacing))
        ])
    }
    
    // Get all data with loading animations
    private func configureData() {
        Task {
            do {
                indicator(animating: .start, completion: nil)
                try await getUserData()
                try await getChatsData()
                
                indicator(animating: .stop) { _ in
                    let nextVC = TabBarController()
                    self.navigate(.root(nextVC))
                }
            } catch {
                print(error)
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
                do {
                    try Storage.shared.logOut()
                    let nextVC = OnboardingViewController()
                    navigate(.rootNavigation(nextVC))
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func getChatsData() async throws {
        let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
        let chats = try await NetworkService.shared.getChats(token: token)
        do {
            try Storage.shared.save(chats, as: .chats, in: .account)
        } catch {
            try Storage.shared.update(chats, as: .chats, in: .account)
        }
    }
    
    private func getUserData() async throws {
        let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
        let userGet = try await NetworkService.shared.getUserInfo(token: token)
        let image = try await NetworkService.shared.getUserImage(imagePath: userGet.image)
        
        let user = User(id: userGet.id,
                        firstName: userGet.first_name,
                        lastName: userGet.last_name ?? "",
                        image: image,
                        phoneNumber: numberFormatter(userGet.phone_number),
                        username: userGet.username)
        
        do {
            try Storage.shared.save(user, as: .user, in: .account)
        } catch {
            try Storage.shared.update(user, as: .user, in: .account)
        }
    }
    
    private func indicator(animating: LoadingIndicator, completion: ((Bool) -> Void)?) {
        switch animating {
        case .start:
            loadingIndicator.startAnimating()
        case .stop:
            loadingIndicator.stopAnimating()
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [.curveLinear],
                           animations: {
                self.nameLabel.alpha = 0
            }, completion: completion)
        }
    }
}
