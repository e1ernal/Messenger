//
//  EditUsernameVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 04.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension EditUsernameViewController {
    internal func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: CGFloat.leastNormalMagnitude))
        
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier,
                                                           for: indexPath) as? TextFieldCell else {
                fatalError("Error: The TableView could not dequeue a \(TextFieldCell.identifier)")
            }
            guard let placeholder = row["placeholder"],
                  let text = row["text"] else {
                return cell
            }
            
            cell.configure(placeholder: placeholder,
                           text: text,
                           tag: indexPath.row,
                           delegate: self)
            return cell
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
}
