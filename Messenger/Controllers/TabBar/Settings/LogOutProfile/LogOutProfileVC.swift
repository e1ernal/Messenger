//
//  UserDetailedViewController.swift
//  Messenger
//
//  Created by e1ernal on 07.02.2024.
//

import UIKit

class LogOutProfileViewController: UITableViewController {
    internal let sections = [
        Section(header: "Log out of your account?",
                footer: """
                        You will be logged out and directed to the login page. Keep in mind that this action cannot be reversed
                        \nRemember to save your progress before signing out, as any unsaved changes or data may be lost
                        """,
                rows: [.regularRow(text: "Log Out")]
               )
    ]
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Configure ViewContriller UI
    private func configureUI() {
        configureVC(title: "Log Out", backButton: true)
        configureTableView()
    }
}
