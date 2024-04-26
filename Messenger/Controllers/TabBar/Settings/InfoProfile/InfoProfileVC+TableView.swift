//
//  InfoProfileVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension InfoProfileViewController {
    internal func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 0,
                                                         height: .const(.doubleSpacing)))
        
        tableView.register(DoubleLabelCell.self, forCellReuseIdentifier: DoubleLabelCell.identifier)
        tableView.register(SquareImageCell.self, forCellReuseIdentifier: SquareImageCell.identifier)
        tableView.allowsSelection = false
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
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
}
