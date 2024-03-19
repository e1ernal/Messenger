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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier,
                                                           for: indexPath) as? ChatCell else {
                fatalError("Error: The TableView could not dequeue a \(ChatCell.identifier)")
            }
            
            guard let image = row["image"]?.toImage(),
                  let name = row["name"],
                  let message = row["message"],
                  let date = row["date"] else {
                return cell
            }
            
            cell.configure(image: image, name: name, message: message, date: date)
            return cell
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        guard let name = row["name"] else {
            return
        }
        
        let nextVC = MessagesVC()
        navigate(.next(nextVC, .fullScreen))
    }
}
