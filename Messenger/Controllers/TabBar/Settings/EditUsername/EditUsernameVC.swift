//
//  EditUsernameViewController.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

class EditUsernameViewController: UITableViewController {
    internal var sections: [Section] = []
    internal var updatedUsername: String?
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSections()
        configureUI()
    }
    
    func configureSections() {
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            sections = [
                Section(header: "Username",
                        footer: """
                            You can choose username on Messenger. If you do, people will de able to find you by this username and contact you without needing your phone number
                            \nYou can use a-z, 0-9 and underscores. Minimum length is 5 characters
                            """,
                        rows: [.textFieldRow(placeholder: "new username", text: user.username)]
                       )
            ]
            tableView.reloadData()
        } catch {
            self.showSnackBar(text: error.localizedDescription,
                              image: .systemImage(.warning, color: nil),
                              on: self)
        }
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
        guard let updatedUsername else { return }
        
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                _ = try await NetworkService.shared.updateUserUsername(username: updatedUsername, token: token)
                let oldUser = try Storage.shared.get(service: .user, as: User.self, in: .account)
                let newUser = User(id: oldUser.id,
                                   firstName: oldUser.firstName,
                                   lastName: oldUser.lastName,
                                   image: oldUser.image,
                                   phoneNumber: oldUser.phoneNumber,
                                   username: updatedUsername)
                
                try Storage.shared.update(newUser, as: .user, in: .account)
                navigate(.back)
            } catch {
                print(error.localizedDescription)
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: .label), on: self)
            }
        }
    }
}
