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
        if messages.isEmpty {
            self.messagesTableView.setEmptyView(name: name)
        } else { self.messagesTableView.restore() }
        
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
                    configureMessages(with: newMessage, withAnimation: false)
                    messagesTableView.reloadData()
                }
            } catch {
                showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
            }
        }
    }
}

extension UITableView {
    func setEmptyView(name: String) {
        let backgroundView = UIView(frame: CGRect(x: self.center.x,
                                                  y: self.center.y,
                                                  width: self.bounds.size.width,
                                                  height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: CGFloat(14), weight: .bold)
        titleLabel.text = "You invited \(name) to join a Chat"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(string: "Chats:\n🔒 Use end-to-end encryption\n🔒 Leave no trace on our servers\n🔒 Do not allow forwarding")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = .constant(.halfSpacing)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, 
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: CGFloat(13), weight: .regular)
        messageLabel.attributedText = attributedString
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        let bubbleView = UIView()
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = .secondarySystemBackground
        bubbleView.layer.cornerRadius = .constant(.cornerRadius)
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = .constant(.spacing)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(messageLabel)
        
        backgroundView.addSubview(bubbleView)
        backgroundView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
            
            titleLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            
            bubbleView.topAnchor.constraint(equalTo: stack.topAnchor, constant: -.constant(.cornerRadius)),
            bubbleView.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -.constant(.cornerRadius)),
            bubbleView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: .constant(.cornerRadius)),
            bubbleView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: .constant(.cornerRadius))
        ])
        
        self.backgroundView = backgroundView
    }
    
    func restore() { self.backgroundView = nil }
}
