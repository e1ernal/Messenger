//
//  Settings.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

protocol UpdateUserDelegate: AnyObject {
    func updateUser(user: User)
}

class SettingsViewController: UITableViewController, UpdateUserDelegate {
    internal var user: User
    internal var sections: [Section] = []
    
    // MARK: - Init UITableViewController
    init(user: User) {
        self.user = user
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
        configureSections()
        configureTableView()
    }
    
    internal func configureSections() {
        sections = [
            Section(rows: [
                .verticalDoubleLabelRow(top: user.firstName + " " + user.lastName,
                                        bottom: "Account & Profile")
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
