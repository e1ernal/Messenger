//
//  Chats.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

struct ChatRow {
    let image: UIImage
    let name: String
    let message: String?
    let date: String?
    let chatId: Int
}

class ChatsViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    internal var chats: [ChatRow] = []
    
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
        configureChatsData()
    }
    
    internal func configureChatsData() {
        Task {
            do {
                try await Storage.shared.getChatsData()
                let chatsData = try Storage.shared.get(service: .chats, as: [Chat].self, in: .account)
                
                chats = []
                for chatData in chatsData {
                    let chatRow = ChatRow(image: try await NetworkService.shared.getUserImage(imagePath: chatData.image),
                                          name: chatData.firstName + " " + chatData.lastName,
                                          message: chatData.lastMessage,
                                          date: chatData.lastMessageCreated?.toChatDate(),
                                          chatId: chatData.directId)
                    chats.append(chatRow)
                }
                tableView.reloadData()
            } catch { print(error) }
        }
    }
    
    // MARK: - Configure ViewController UI
    private func configureUI() {
        configureSearchController()
        configureTableView()
        configureNavigationBar()
    }
}
