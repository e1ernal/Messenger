//
//  CGColor.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import UIKit

extension CGColor {
    static func color(_ name: Color) -> CGColor {
        guard let color = UIColor(named: name.rawValue) else {
            return UIColor.black.cgColor
        }
        return color.cgColor
    }
}
