//
//  Navigation.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import UIKit

enum Navigation {
    case next(UIViewController, Style)
    case back
    case root(UIViewController)
    case rootNavigation(UIViewController)
    
    enum Style {
        case fullScreen
        case pageSheet([UISheetPresentationController.Detent])
    }
}
