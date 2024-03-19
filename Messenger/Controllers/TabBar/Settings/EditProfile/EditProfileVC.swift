//
//  EditProfileViewController.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

class EditProfileViewController: UITableViewController {
    internal var sections: [Section] = []
    internal var updatedUser: (firstName: String?, lastName: String?, image: UIImage?)
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSections()
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureVC(title: "Edit Profile", backButton: true)
        configureTableView()
        configureNavigationBar()
        
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            updatedUser = (user.firstName, user.lastName, user.image)
        } catch {
            print(error)
        }
    }
    
    internal func configureSections() {
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            
            sections = [
                Section(rows: [
                    .imageWithButtonRow(image: updatedUser.image?.toString() ?? user.image.toString(), buttonText: "Set New Photo")
                ]),
                Section(footer: "Enter your name and add an optional profile photo",
                        rows: [
                            .textFieldRow(placeholder: "first name (required)", text: user.firstName),
                            .textFieldRow(placeholder: "last name (optional)", text: user.lastName)
                        ]),
                Section(rows: [
                    .doubleLabelRow(left: "username", right: "@" + user.username)
                ])
            ]
            tableView.reloadData()
        } catch {
            self.showSnackBar(text: error.localizedDescription,
                              image: .systemImage(.warning, color: nil),
                              on: self)
        }
    }
}
