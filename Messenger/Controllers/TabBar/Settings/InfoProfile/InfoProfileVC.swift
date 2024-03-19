//
//  infoProfileViewController.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import UIKit

class InfoProfileViewController: UITableViewController {
    internal var sections: [Section] = []
    
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
        configureVC(title: "Profile", backButton: true)
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureSections() {
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            sections = [
                Section(rows: [
                    .imageRow(image: user.image.toString())
                ]),
                Section(header: "Profile Info",
                        footer: "",
                        rows: [
                            .doubleLabelRow(left: "name", right: user.firstName + " " + user.lastName),
                            .doubleLabelRow(left: "username", right: "@" + user.username),
                            .doubleLabelRow(left: "mobile", right: user.phoneNumber)
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
