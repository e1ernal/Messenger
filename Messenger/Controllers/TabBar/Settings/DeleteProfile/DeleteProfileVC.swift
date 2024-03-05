//
//  deleteProfileViewController.swift
//  Messenger
//
//  Created by e1ernal on 11.02.2024.
//

import UIKit

class DeleteProfileViewController: UITableViewController {
    internal let sections = [
        Section(header: "Delete your account?",
                footer: """
                        Deleting your account will:
                        • Delete your account info and profile photo
                        • Delete your message history
                        """,
                rows: [.regularRow(text: "Delete my account")]
               )
    ]
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Configure ViewContriller UI
    private func configureUI() {
        configureVC(title: "Delete Account", backButton: true)
        configureTableView()
    }
}
