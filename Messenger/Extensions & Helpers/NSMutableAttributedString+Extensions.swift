//
//  NSMutableAttributedString+Extensions.swift
//  Messenger
//
//  Created by e1ernal on 03.01.2024.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func font(_ value: String, font: UIFont) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func highlighted(_ value: String, font: UIFont, foregroundColor: UIColor, backgroundColor: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: foregroundColor,
            .backgroundColor: backgroundColor
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func underlined(_ value: String, font: UIFont) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
