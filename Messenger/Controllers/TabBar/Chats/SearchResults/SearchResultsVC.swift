//
//  s.swift
//  Messenger
//
//  Created by e1ernal on 23.02.2024.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    internal var searchResults: [User] = []
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureTableView()
    }
}
