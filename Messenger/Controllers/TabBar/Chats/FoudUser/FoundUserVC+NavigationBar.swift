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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(backBarButtonClicked))
    }
    
    @objc func backBarButtonClicked() {
        dismiss(animated: true)
    }
}
