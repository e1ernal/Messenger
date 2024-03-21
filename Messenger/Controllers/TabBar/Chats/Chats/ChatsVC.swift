//
//  Chats.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class ChatsViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    internal var sections: [Section] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSections()
    }
    
    internal func configureSections() {
        Task {
            do {
                try await Storage.shared.getChatsData()
                let chats = try Storage.shared.get(service: .chats, as: [Chat].self, in: .account)
                
                guard !chats.isEmpty else {
                    return
                }
                
                var section = Section()
                for chat in chats {
                    let image = try await NetworkService.shared.getUserImage(imagePath: chat.image)
                    section.rows.append(.chatRow(image: image.toString(),
                                                 name: chat.first_name + " " + chat.last_name,
                                                 message: chat.last_message ?? "",
                                                 date: chat.last_message_created?.toChatDate() ?? "",
                                                 chatId: String(chat.direct_id))
                    )
                }
                if sections.isEmpty {
                    sections.append(section)
                } else {
                    sections[0] = section
                }
                
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureSearchController()
        configureTableView()
        configureNavigationBar()
    }
}
