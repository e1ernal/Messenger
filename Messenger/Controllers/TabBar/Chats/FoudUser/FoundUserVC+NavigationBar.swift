//
//  FoundUserVC+NavigationBar.swift
//  Messenger
//
//  Created by e1ernal on 05.03.2024.
//

import UIKit

// MARK: - Configure Navigation Bar
extension FoundUserTableViewController {
    internal func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(leftBarButtonClicked))
    }
    
    // Navigate back to search results
    @objc func leftBarButtonClicked() {
        dismiss(animated: true)
    }
}
