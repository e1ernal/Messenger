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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messages[indexPath.row] {
        case let .message(messageRow):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier,
                                                           for: indexPath) as? MessageCell else {
                fatalError("Error: The TableView could not dequeue a \(MessageCell.identifier)")
            }
            
            let isReceived = messageRow.authorId == userId ? false : true
            
            cell.configure(message: messageRow.message,
                           side: isReceived ? .left : .right,
                           superViewWidth: view.frame.width,
                           time: messageRow.time)
            return cell
        case let .section(sectionRow):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageSectionCell.identifier,
                                                           for: indexPath) as? MessageSectionCell else {
                fatalError("Error: The TableView could not dequeue a \(MessageSectionCell.identifier)")
            }
            
            cell.configure(date: sectionRow.sectionDate)
            return cell
        }
    }
    
    internal func configureTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        messagesTableView.register(MessageSectionCell.self, forCellReuseIdentifier: MessageSectionCell.identifier)
        configureMessages()
    }
    
    // Get messages in chat
    private func configureMessages() {
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                let messagesData = try await NetworkService.shared.getMessages(chatId: chatId, token: token)
                
                for messageData in messagesData {
                    let newMessage = MessageRow(authorId: messageData.author.id,
                                                message: messageData.text,
                                                date: messageData.createdAt,
                                                time: messageData.createdAt.toTime())
                    _ = configureMessages(with: newMessage)
                }
                messagesTableView.reloadData()
                messagesTableView.scrollToBottom()
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
            }
        }
    }
}
