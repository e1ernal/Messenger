//
//  SearchResults+TableView.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Table View
extension SearchResultsTableViewController {
    internal func configureTableView() {
        tableView.register(SearchResultsCell.self,
                           forCellReuseIdentifier: SearchResultsCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? 0 : searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchResults.isEmpty ? "No results" : "Global Search"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsCell.identifier,
                                                       for: indexPath) as? SearchResultsCell else {
            fatalError("Error: The TableView could not dequeue a \(SearchResultsCell.identifier)")
        }
        
        let userData = self.searchResults[indexPath.row]
        cell.setupCell(image: userData.image,
                       name: userData.firstName + " " + userData.lastName,
                       username: userData.username)
        return cell
    }
    
    // MARK: - Update Table View
    func updateSearchResults(results: [User]) {
        searchResults = results
        tableView.reloadData()
    }
    
    // MARK: - Clear Table View
    func clearSearchResults() {
        searchResults = []
        tableView.reloadData()
    }
    
    // MARK: - Show found user in
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.searchResults[indexPath.row]
        
        let nextVC = UINavigationController(rootViewController: FoundUserTableViewController(user: user))
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
