//
//  FoundUser+TableView.swift
//  Messenger
//
//  Created by e1ernal on 07.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension FoundUserTableViewController {
    internal func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: .const(.doubleSpacing)))
        
        tableView.register(DoubleLabelCell.self, forCellReuseIdentifier: DoubleLabelCell.identifier)
        tableView.register(SquareImageCell.self, forCellReuseIdentifier: SquareImageCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SquareImageCell.identifier,
                                                           for: indexPath) as? SquareImageCell else {
                fatalError("Error: The TableView could not dequeue a \(SquareImageCell.identifier)")
            }
            
            if let image = row["image"]?.toImage() {
                cell.configure(image: image)
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DoubleLabelCell.identifier,
                                                           for: indexPath) as? DoubleLabelCell else {
                fatalError("Error: The TableView could not dequeue a \(DoubleLabelCell.identifier)")
            }
            
            if let leftText = row["left"], let rightText = row["right"] {
                cell.configure(left: leftText, right: rightText)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var background = UIBackgroundConfiguration.listSidebarCell()
            background.backgroundColor = .active
            
            var content = UIListContentConfiguration.cell()
            let row = sections[indexPath.section].rows[indexPath.row].getValue()
            if let text = row["text"] { content.text = text }
            content.textProperties.alignment = .center
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = background
            return cell
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2 && indexPath.row == 0 else { return }
        
        Task {
            do {
                var chats = try Storage.shared.get(service: .chats, as: [Chat].self, in: .account)
                if !chats.contains(where: { $0.username == user.username }) {
                    let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                    
                    // Generate symmetric key and encrypt it
                    let symmetricKey = SymmetricEncryption.shared.generateKey()
                    let encryptedKey = try AsymmetricEncryption.shared.encrypt(message: symmetricKey, publicKey: user.publicKey)
                    print("Encrypted with: ", user.publicKey.prefix(20))
                    
                    // Create chat with user
                    try await NetworkService.shared.createChatWithUser(userId: user.id,
                                                                       token: token,
                                                                       encrypted_key: encryptedKey)
                    
                    // Get all chats and update local storage
                    chats = try await NetworkService.shared.getChats(token: token)
                    try Storage.shared.update(chats, as: .chats, in: .account)
                    
                    // Get new chat id
                    let newChat = chats.first { $0.username == user.username }
                    let newChatId = newChat?.directChat.id
                    
                    // Update local storage with symmetric keys
                    var symmetricKeys = ChatSymmetricKey()
                    do {
                        // Case when there are some symmetric keys
                        symmetricKeys = try Storage.shared.get(service: .symmetricKeys,
                                                               as: ChatSymmetricKey.self,
                                                               in: .account)
                    } catch {
                        // Case when there aren't some symmetric keys
                        symmetricKeys = ChatSymmetricKey()
                    }
                    
                    if let newChatId {
                        symmetricKeys.insert(chatId: newChatId, symmetricKey: symmetricKey)
                    }
                    do { try Storage.shared.update(symmetricKeys, as: .symmetricKeys, in: .account)
                    } catch {try Storage.shared.save(symmetricKeys, as: .symmetricKeys, in: .account)}
                    
                    Storage.shared.showAllData()
                    navigate(.back)
                }
                dismiss(animated: true)
            } catch {
                Print.error(screen: self, action: #function, reason: error, show: true)
            }
        }
    }
}
