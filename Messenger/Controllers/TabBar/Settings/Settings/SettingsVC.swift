//
//  Settings.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class SettingsViewController: UITableViewController {
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
        configureTableView()
    }
    
    internal func configureSections() {
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            sections = [
                Section(rows: [
                    .imageDoubleLabelRow(image: user.image.toString(), 
                                         top: user.firstName + " " + user.lastName,
                                         bottom: "Account & Profile")
                ]),
                Section(rows: [
                    .settingsRow(image: UIImage.systemImage(.privacy).toString(),
                                 text: "Privacy and Security"),
                    .settingsRow(image: UIImage.systemImage(.cylinder).toString(),
                                 text: "Data and Storage"),
                    .settingsRow(image: UIImage.systemImage(.appearance).toString(),
                                 text: "Appearance"),
                    .settingsRow(image: UIImage.systemImage(.language).toString(),
                                 text: "Language",
                                 detailedText: "English")
                ]),
                Section(rows: [
                    .settingsRow(image: UIImage.systemImage(.info).toString(),
                                 text: "About"),
                    .settingsRow(image: UIImage.systemImage(.help).toString(),
                                 text: "Help")
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
