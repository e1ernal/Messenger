//
//  Settings.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class SettingsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        setupVC(title: TabBarItem.settings.title, backButton: false)
    }
}
