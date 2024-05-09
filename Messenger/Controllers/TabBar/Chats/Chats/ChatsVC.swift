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
    let dateString: String?
    let date: Int?
    let created: Int
    let chatId: Int
    let symmetricKey: String
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
        tabBarController?.tabBar.isHidden = false
        configureChatsData()
    }
    
    internal func configureChatsData() {
        Task {
            do {
                try await Storage.shared.getChatsData()
                let chatsData = try Storage.shared.get(service: .chats, as: [Chat].self, in: .account)
                
                var symmetricKeysIsEmpty = false
                var symmetricKeys: ChatSymmetricKey
                do { symmetricKeys = try Storage.shared.get(service: .symmetricKeys, as: ChatSymmetricKey.self, in: .account)
                } catch { 
                    symmetricKeys = ChatSymmetricKey()
                    symmetricKeysIsEmpty = true
                }
                
                chats = []
                for chatData in chatsData {
                    var symmetricKey: String
                    if symmetricKeys.containsKey(chatId: chatData.directChat.id) {
                        symmetricKey = try symmetricKeys.getKey(chatId: chatData.directChat.id)
                    } else {
                        let encryptedSymmetricKey = chatData.directChat.encryptedSymmetricKey
                        let privateKey = try Storage.shared.get(service: .privateKey, as: String.self, in: .account)
                        symmetricKey = try AsymmetricEncryption.shared.decrypt(message: encryptedSymmetricKey, privateKey: privateKey)
                        
                        symmetricKeys.insert(chatId: chatData.directChat.id, symmetricKey: symmetricKey)
                        if symmetricKeysIsEmpty {
                            try Storage.shared.save(symmetricKeys, as: .symmetricKeys, in: .account)
                        } else {
                            try Storage.shared.update(symmetricKeys, as: .symmetricKeys, in: .account)
                        }
                    }
                    
                    var encryptedLastMessage = ""
                    if let lastMessage = chatData.lastMessage {
                        let decryptedLastMessage = try SymmetricEncryption.shared.decrypt(message: lastMessage, key: symmetricKey)
                        encryptedLastMessage = decryptedLastMessage
                    }
                    
                    let chatRow = ChatRow(image: try await NetworkService.shared.getUserImage(imagePath: chatData.image),
                                          name: chatData.firstName + " " + chatData.lastName,
                                          message: encryptedLastMessage,
                                          dateString: chatData.lastMessageCreated?.toChatDate(),
                                          date: chatData.lastMessageCreated,
                                          created: chatData.directChat.createdAt,
                                          chatId: chatData.directChat.id, 
                                          symmetricKey: chatData.directChat.encryptedSymmetricKey)
                    chats.append(chatRow)
                }
                chats.sort { $0.date ?? $0.created > $1.date ?? $1.created }
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
