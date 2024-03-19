//
//  DeleteProfileVC+TableView.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension DeleteProfileViewController {
    internal func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let row = sections[indexPath.section].rows[indexPath.row].getValue()
        if let text = row["text"] { content.text = text }
        content.textProperties.alignment = .center
        content.textProperties.color = .failure
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Delete Profile
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            do {
                let token = try Storage.shared.get(service: .token, as: String.self, in: .account)
                try await NetworkService.shared.deleteUser(token: token)
                try Storage.shared.logOut()
                
                let nextVC = OnboardingViewController()
                navigate(.rootNavigation(nextVC))
            } catch {
                self.showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
            }
        }
    }
}
