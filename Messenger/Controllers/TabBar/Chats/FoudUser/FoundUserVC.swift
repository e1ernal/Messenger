//
//  FoundUserViewController.swift
//  Messenger
//
//  Created by e1ernal on 02.03.2024.
//

import UIKit

class FoundUserTableViewController: UITableViewController {
    internal var user: User
    internal var sections: [Section]
    
    // MARK: - Init UITableViewController
    init(user: User) {
        self.user = user
        sections = [
            Section(rows: [.emptyRow]),
            Section(header: "Profile Info",
                    rows: [
                        .doubleLabelRow(left: "username", right: "@" + user.username),
                        .doubleLabelRow(left: "mobile", right: user.phoneNumber)
                    ]),
            Section(rows: [
                .regularRow(text: "Send a Message")
            ])
        ]
        
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
    
    private func configureUI() {
        configureVC(title: user.firstName + " " + user.lastName, backButton: true)
        configureTableView()
        configureNavigationBar()
    }
}
