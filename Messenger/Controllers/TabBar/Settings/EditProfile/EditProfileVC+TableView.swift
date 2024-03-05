//
//  EditProfileVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension EditProfileViewController {
    internal func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: CGFloat.leastNormalMagnitude))
 
        tableView.register(DoubleLabelTableViewCell.self, forCellReuseIdentifier: DoubleLabelTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(ImageWithButtonTableViewCell.self, forCellReuseIdentifier: ImageWithButtonTableViewCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageWithButtonTableViewCell.identifier,
                                                           for: indexPath) as? ImageWithButtonTableViewCell else {
                fatalError("Error: The TableView could not dequeue a \(ImageWithButtonTableViewCell.identifier)")
            }
            
            cell.configure(image: user.image, text: "Set New Photo", delegate: self)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                fatalError("Error: The TableView could not dequeue a \(TextFieldTableViewCell.identifier)")
            }
            
            let row = sections[indexPath.section].rows[indexPath.row].getValue()
            if let placeholder = row["placeholder"], let text = row["text"] {
                cell.configure(placeholder: placeholder, text: text, tag: indexPath.row, delegate: self)
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DoubleLabelTableViewCell.identifier,
                                                           for: indexPath) as? DoubleLabelTableViewCell else {
                fatalError("Error: The TableView could not dequeue a \(DoubleLabelTableViewCell.identifier)")
            }
            
            let row = sections[indexPath.section].rows[indexPath.row].getValue()
            if let leftText = row["left"], let rightText = row["right"] {
                cell.configure(left: leftText, right: rightText)
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let nextVC = EditUsernameViewController(username: user.username, delegate: self)
            navigate(.next(nextVC, .fullScreen))
        }
    }
}