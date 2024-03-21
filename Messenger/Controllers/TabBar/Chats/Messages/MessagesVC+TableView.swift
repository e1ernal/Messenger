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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let keys = messages.keys.sorted()
        let headerText = keys[section]
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = headerText
        label.textColor = .inactive
        label.backgroundColor = .background
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .font(.header)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = (label.intrinsicContentSize.height + .constant(.spacing)) * 0.5
        
        let header = UIView()
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: .constant(.spacing)),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -.constant(.spacing)),
            label.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + .constant(.spacing)),
            label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height + .constant(.spacing))
        ])
        
        return header
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
