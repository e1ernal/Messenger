//
//  ChatsVC+SearchController.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Search Controller Methods
extension ChatsViewController {
    internal func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsViewController = searchController.searchResultsController as? SearchResultsTableViewController else {
            return
        }
        
        guard let text = searchController.searchBar.text,
              !text.isEmpty else {
            resultsViewController.clearSearchResults()
            return
        }
        
        Task {
            do {
                guard let userToken = UserDefaults.getUserToken() else {
                    throw DescriptionError.error("No user token")
                }
                
                let usersGet = try await NetworkService.shared.searchUsersByUsername(username: text, token: userToken)
                var users: [User] = []
                for user in usersGet {
                    let image = try await NetworkService.shared.getUserImage(imagePath: user.image)
                    let user = User(firstName: user.first_name,
                                    lastName: user.last_name ?? "",
                                    image: image,
                                    phoneNumber: user.phone_number,
                                    username: user.username)
                    users.append(user)
                }
                resultsViewController.updateSearchResults(results: users)
            } catch {
                self.showSnackBar(text: error.localizedDescription, image: .systemImage(.warning, color: nil), on: self)
            }
        }
    }
}
