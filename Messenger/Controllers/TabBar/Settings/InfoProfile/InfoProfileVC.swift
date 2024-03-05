//
//  infoProfileViewController.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import UIKit

class InfoProfileViewController: UITableViewController, UpdateUserDelegate {
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
        
        configureSections()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            delegate?.updateUser(user: user)
        }
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureVC(title: "Profile", backButton: true)
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureSections() {
        sections = [
            Section(rows: [.emptyRow]),
            Section(header: "Profile Info",
                    footer: "",
                    rows: [
                        .doubleLabelRow(left: "name", right: user.firstName + " " + user.lastName),
                        .doubleLabelRow(left: "username", right: "@" + user.username),
                        .doubleLabelRow(left: "mobile", right: user.phoneNumber)
                    ])
        ]
        tableView.reloadData()
    }
    
    // MARK: - Protocol Methods
    func updateUser(user: User) {
        self.user = user
        configureSections()
    }
}
