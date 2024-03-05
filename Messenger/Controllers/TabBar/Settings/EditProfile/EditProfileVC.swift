//
//  EditProfileViewController.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

protocol UpdateUsernameDelegate: AnyObject {
    func updateUsername(username: String)
}

class EditProfileViewController: UITableViewController, UpdateUsernameDelegate, SetNewPhotoDelegate {
    internal var user: User
    internal var sections: [Section] = []
    weak var delegate: UpdateUserDelegate?
    
    // MARK: - Init UITableViewController
    init(user: User, delegate: UpdateUserDelegate) {
        self.user = user
        self.delegate = delegate
        super.init(style: .insetGrouped)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureVC(title: "Edit Profile", backButton: true)
        configureSections()
        configureTableView()
        configureNavigationBar()
    }
    
    internal func configureSections() {
        sections = [
            Section(rows: [.emptyRow]),
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
    }
    
    // MARK: - Protocol Methods
    func updateUsername(username: String) {
        user.username = username
        configureSections()
    }
    
    func setNewPhoto() {
        showImagePickerControllerActionSheet()
    }
}
