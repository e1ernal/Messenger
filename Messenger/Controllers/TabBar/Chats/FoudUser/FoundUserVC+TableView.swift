//
//  FoundUserVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension FoundUserTableViewController {
    internal func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(DoubleLabelTableViewCell.self, forCellReuseIdentifier: DoubleLabelTableViewCell.identifier)
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: .constant(.doubleSpacing)))
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier,
                                                           for: indexPath) as? ImageTableViewCell else {
                fatalError("Error: The TableView could not dequeue a \(ImageTableViewCell.identifier)")
            }
            
            cell.configure(image: user.image)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DoubleLabelTableViewCell.identifier,
                                                           for: indexPath) as? DoubleLabelTableViewCell else {
                fatalError("Error: The TableView could not dequeue a \(DoubleLabelTableViewCell.identifier)")
            }
            
            let row = sections[indexPath.section].rows[indexPath.row].getValue()
            if let leftText = row["left"], let rightText = row["right"] {
                cell.configure(left: leftText, right: rightText)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "Send a message"
            content.textProperties.alignment = .center
            content.textProperties.color = .active
            cell.contentConfiguration = content
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
