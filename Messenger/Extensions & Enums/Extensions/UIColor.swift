//
//  UIColor.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import UIKit

extension UIColor {
    static func color(_ name: Color) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            return .black
        }
        return color
    }
}
