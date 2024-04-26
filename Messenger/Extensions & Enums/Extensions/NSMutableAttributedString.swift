//
//  NSMutableAttributedString.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func font(_ value: String,
              _ font: UIFont) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func highlighted(_ value: String,
                     _ font: UIFont,
                     foreground: UIColor,
                     background: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: foreground,
            .backgroundColor: background
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func underlined(_ value: String,
                    _ font: UIFont) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
