//
//  ChatsVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 07.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension ChatsViewController {
    internal func configureTableView() {
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier,
                                                       for: indexPath) as? ChatCell else {
            fatalError("Error: The TableView could not dequeue a \(ChatCell.identifier)")
        }
        
        let row = chats[indexPath.row]
        cell.configure(image: row.image,
                       name: row.name,
                       message: row.message,
                       date: row.date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = chats[indexPath.row]
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            let nextVC = MessagesVC(name: row.name,
                                    image: row.image,
                                    chatId: row.chatId,
                                    userId: user.id)
            navigate(.next(nextVC, .fullScreen))
        } catch { print(error) }
    }
}
