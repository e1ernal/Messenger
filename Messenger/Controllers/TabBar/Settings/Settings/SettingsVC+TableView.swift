//
//  SettingsVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension SettingsViewController {
    internal func configureTableView() {
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.register(DetailedCell.self, forCellReuseIdentifier: DetailedCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier,
                                                           for: indexPath) as? ProfileCell else {
                fatalError("Error: The TableView could not dequeue a \(ProfileCell.identifier)")
            }
            
            if let image = row["image"]?.toImage(),
               let top = row["top"],
               let bottom = row["bottom"] {
                cell.configure(image: image, title: top, subtitle: bottom)
            }
            
            return cell
        default:
            switch indexPath.row {
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailedCell.identifier,
                                                               for: indexPath) as? DetailedCell else {
                    fatalError("Error: The TableView could not dequeue a \(DetailedCell.identifier)")
                }
                
                if let image = row["image"]?.toImage(),
                    let text = row["text"],
                    let detailedText = row["detailedText"] {
                        cell.configure(image: image, titleText: text, detailText: detailedText)
                    }
                
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier,
                                                               for: indexPath) as? SettingsCell else {
                    fatalError("Error: The TableView could not dequeue a \(SettingsCell.identifier)")
                }
                
                if let image = row["image"]?.toImage(),
                    let text = row["text"] {
                        cell.configure(image: image, text: text)
                    }
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, indexPath.row == 0 {
            let nextVC = InfoProfileViewController(style: .insetGrouped)
            self.navigate(.next(nextVC, .fullScreen))
        }
    }
}
