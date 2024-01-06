//
//  Chats.swift
//  Messenger
//
//  Created by e1ernal on 02.12.2023.
//

import UIKit

class ChatsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        setupVC(title: TabBarItem.chats.title, backButton: false)
    }
}
