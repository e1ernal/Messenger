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
        tableView.register(ImageWithLabelsTableViewCell.self, 
                           forCellReuseIdentifier: ImageWithLabelsTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageWithLabelsTableViewCell.identifier,
                                                       for: indexPath) as? ImageWithLabelsTableViewCell else {
            fatalError("Error: The TableView could not dequeue a \(ImageWithLabelsTableViewCell.identifier)")
        }
        
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        if let top = row["top"], let bottom = row["bottom"] {
            cell.configure(image: user.image,
                           title: top,
                           subtitle: bottom)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = InfoProfileViewController(user: user, delegate: self)
        self.navigate(.next(nextVC, .fullScreen))
    }
}
