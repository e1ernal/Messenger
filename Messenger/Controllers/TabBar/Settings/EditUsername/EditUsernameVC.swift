//
//  EditUsernameViewController.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

class EditUsernameViewController: UITableViewController {
    internal var username: String
    internal var sections: [Section] = []
    internal var updatedUsername: (isAvailable: Bool, username: String)
    weak var delegate: UpdateUsernameDelegate?
    
    // MARK: - Init UITableViewController
    init(username: String, delegate: UpdateUsernameDelegate) {
        self.username = username
        self.delegate = delegate
        self.updatedUsername = (false, "")
        
        super.init(style: .insetGrouped)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSections()
        configureUI()
    }
    
    func configureSections() {
        sections = [
            Section(header: "Username",
                    footer: """
                            You can choose username on Messenger. If you do, people will de able to find you by this username and contact you without needing your phone number
                            \nYou can use a-z, 0-9 and underscores. Minimum length is 5 characters
                            """,
                    rows: [.textFieldRow(placeholder: "new username", text: username)]
                   )
        ]
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureVC(title: "Username", backButton: true)
        configureTableView()
        configureNavigationBar()
    }
    
    // MARK: - Configure Navigation Bar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveTapped))
    }
    
    // MARK: - Navigation Bar Actions
    // Save new username and navigate back
    @objc func saveTapped() {
        guard updatedUsername.isAvailable else { return }
        
        Task {
            do {
                guard let userToken = UserDefaults.getUserToken() else {
                    throw DescriptionError.error("No user token")
                }
                
                let userGet = try await NetworkService.shared.updateUserUsername(username: updatedUsername.username, token: userToken)
                
                delegate?.updateUsername(username: userGet.username)
                navigate(.back)
            } catch {
                print(updatedUsername)
                print(error.localizedDescription)
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
}
