//
//  Button.swift
//  Messenger
//
//  Created by e1ernal on 06.01.2024.
//

import Foundation

enum Button {
    case filled(_ state: ViewState)
    case clear(_ state: ViewState)
}

enum ViewState {
    case active
    case inactive
}
