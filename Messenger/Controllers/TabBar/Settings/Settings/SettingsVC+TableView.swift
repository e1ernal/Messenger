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
        tableView.register(ProfileCell.self, 
                           forCellReuseIdentifier: ProfileCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
            
            guard let image = row["image"]?.toImage(),
                  let top = row["top"],
                  let bottom = row["bottom"] else {
                return cell
            }
            cell.configure(image: image,
                           title: top,
                           subtitle: bottom)
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            fatalError("Error: Can't configure Cell for TableView")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = InfoProfileViewController(style: .insetGrouped)
        self.navigate(.next(nextVC, .fullScreen))
    }
}
