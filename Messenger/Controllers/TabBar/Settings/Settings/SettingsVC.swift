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
