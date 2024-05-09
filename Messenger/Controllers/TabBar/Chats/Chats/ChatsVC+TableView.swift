//
//  ChatsVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 07.03.2024.
//

import CryptoKit
import UIKit

// MARK: - Configure Table View
extension ChatsViewController {
    internal func configureTableView() {
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
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
                       date: row.dateString)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = chats[indexPath.row]
        do {
            let user = try Storage.shared.get(service: .user, as: User.self, in: .account)
            var symmetricKeys: ChatSymmetricKey
            do {
                symmetricKeys = try Storage.shared.get(service: .symmetricKeys, as: ChatSymmetricKey.self, in: .account)
            } catch {
                symmetricKeys = ChatSymmetricKey()
            }
            
            var symmetricKey: String
            if symmetricKeys.containsKey(chatId: row.chatId) {
                symmetricKey = try symmetricKeys.getKey(chatId: row.chatId)
            } else {
                let encryptedSymmetricKey = row.symmetricKey
                let privateKey = try Storage.shared.get(service: .privateKey, as: String.self, in: .account)
                symmetricKey = try AsymmetricEncryption.shared.decrypt(message: encryptedSymmetricKey, privateKey: privateKey)
                
                symmetricKeys.insert(chatId: row.chatId, symmetricKey: symmetricKey)
                try Storage.shared.update(symmetricKeys, as: .symmetricKeys, in: .account)
            }
            let nextVC = MessagesVC(name: row.name,
                                    image: row.image,
                                    chatId: row.chatId,
                                    userId: user.id,
                                    symmetricKey: symmetricKey)
            navigate(.next(nextVC, .fullScreen))
        } catch {
            Print.error(screen: self, action: #function, reason: error, show: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !chats.isEmpty else { return UIView() }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage.systemImage(.lock)
            .withConfiguration(UIImage.SymbolConfiguration(scale: .small))
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let footerString = NSMutableAttributedString()
        footerString.append(imageString)
        footerString.append(NSMutableAttributedString()
            .font(" Your private chats are ", .systemFont(ofSize: CGFloat(11), weight: .light), .center)
            .font("end-to-end encrypted", .systemFont(ofSize: CGFloat(11), weight: .medium), .center)
        )
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor.inactive]
        footerString.addAttribute(.baselineOffset,
                                  value: 2,
                                  range: NSRange(location: 1, length: footerString.length - 1))
        footerString.addAttributes(attributedStringColor,
                                   range: NSRange(location: 0, length: footerString.length))
        
        let footerLabel = UILabel()
        footerLabel.attributedText = footerString
        footerLabel.textAlignment = .center
        footerLabel.isUserInteractionEnabled = true
        
        let clickGesture = UITapGestureRecognizer(target: self, action: #selector(didClickFooter))
        footerLabel.addGestureRecognizer(clickGesture)
        
        return footerLabel
    }
    
    @objc func didClickFooter() {
        //        navigate(.next(EncryptionInfoVC(), .pageSheet([.medium()])))
    }
}
