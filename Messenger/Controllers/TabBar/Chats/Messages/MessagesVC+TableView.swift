//
//  MessagesVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 20.03.2024.
//

import UIKit

// MARK: - Configure Messages TableView
extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = messages.keys.sorted()
        guard let section = messages[keys[section]] else {
            return 0
        }
        
        return section.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = messages.keys.sorted()
        return keys[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let keys = messages.keys.sorted()
        let headerText = keys[section]
        
        let headerView = UILabel(frame: CGRect(x: 0, 
                                               y: 0,
                                               width: tableView.frame.width,
                                               height: .constant(.doubleSpacing)))
        
        headerView.backgroundColor = .systemBackground
        headerView.textAlignment = .center
        headerView.font = .font(.header)
        
        headerView.text = headerText
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier,
                                                       for: indexPath) as? MessageCell else {
            fatalError("Error: The TableView could not dequeue a \(MessageCell.identifier)")
        }
        
        let keys = messages.keys.sorted()
        guard let section = messages[keys[indexPath.section]] else {
            fatalError("Error: The TableView could not dequeue a \(MessageCell.identifier)")
        }
        
        let message = section[indexPath.row]
        var isReceived = false
        
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            isReceived = message.author.id == user.id ? false : true
        } catch {
            print(error)
        }
        
        cell.configure(message: message.text,
                       side: isReceived ? .left : .right,
                       superViewWidth: view.frame.width,
                       time: message.createdAt.toMessageTime())
        return cell
    }
    
    internal func configureTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        configureMessages()
    }
    
    // Get messages in chat
    private func configureMessages() {
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                let allMessages = try await NetworkService.shared.getMessages(chatId: chatId, token: token)
                messages = Dictionary(grouping: allMessages) { $0.createdAt.toMessageDate() }
                messagesTableView.reloadData()
            } catch {
                print(error)
            }
            messagesTableView.scrollToBottom()
        }
    }
}
