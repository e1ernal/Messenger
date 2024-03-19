//
//  EditProfileVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension EditProfileViewController: SetNewPhotoDelegate {
    internal func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: CGFloat.leastNormalMagnitude))
 
        tableView.register(DoubleLabelCell.self, forCellReuseIdentifier: DoubleLabelCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(ImageWithButtonCell.self, forCellReuseIdentifier: ImageWithButtonCell.identifier)
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
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageWithButtonCell.identifier,
                                                           for: indexPath) as? ImageWithButtonCell else {
                fatalError("Error: The TableView could not dequeue a \(ImageWithButtonCell.identifier)")
            }
            
            guard let image = row["image"]?.toImage(),
                  let buttonText = row["buttonText"] else {
                return cell
            }
            
            cell.configure(image: image, text: buttonText, delegate: self)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier,
                                                           for: indexPath) as? TextFieldCell else {
                fatalError("Error: The TableView could not dequeue a \(TextFieldCell.identifier)")
            }
            
            if let placeholder = row["placeholder"], let text = row["text"] {
                cell.configure(placeholder: placeholder, text: text, tag: indexPath.row, delegate: self)
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DoubleLabelCell.identifier,
                                                           for: indexPath) as? DoubleLabelCell else {
                fatalError("Error: The TableView could not dequeue a \(DoubleLabelCell.identifier)")
            }
            
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
            let nextVC = EditUsernameViewController(style: .insetGrouped)
            navigate(.next(nextVC, .fullScreen))
        }
    }
}
