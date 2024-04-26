//
//  Colors.swift
//  Messenger
//
//  Created by e1ernal on 05.01.2024.
//

import UIKit

enum Color: String {
    // Background
    case background = "Background"
    case secondaryBackground = "BackgroundSecondary"
    case transparentBackground = "BackgroundTransparent"
    
    // Elements
    case active = "Active"
    case inactive = "Inactive"
    case pageControlCurrent = "PageControlCurrent"
    case pageControlTint = "PageControlTint"
    
    // Result
    case success = "Success"
    case failure = "Failure"
}

extension UIColor {
    static func color(_ name: Color) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            return .black
        }
        return color
    }
}

extension CGColor {
    static func color(_ name: Color) -> CGColor {
        guard let color = UIColor(named: name.rawValue) else {
            return UIColor.black.cgColor
        }
        return color.cgColor
    }
}
