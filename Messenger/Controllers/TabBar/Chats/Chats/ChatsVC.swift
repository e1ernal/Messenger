//
//  Chats.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class ChatsViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    internal let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsTableViewController(style: .insetGrouped))
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        return searchController
    }()
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureSearchController()
    }
}
