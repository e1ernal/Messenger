//
//  NSMutableAttributedString+Extensions.swift
//  Messenger
//
//  Created by e1ernal on 03.01.2024.
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

extension String {
    func leftPadding(toLength: Int, withPad: String) -> String {
        String(String(reversed()).padding(toLength: toLength, withPad: withPad, startingAt: 0).reversed())
    }
}

// MARK: Convert String-UIImage
extension String {
    func toImage() -> UIImage {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return UIImage()
        }
        return image
    }
}

extension UIImage {
    func toString() -> String {
        let data = self.pngData()
        guard let stringImage = data?.base64EncodedString(options: .endLineWithLineFeed) else {
            return ""
        }
        return stringImage
    }
}

extension String {
    func toDate() -> String {
        let prefixInputDate = self.prefix { $0 != "." }
        
        // Convert String to Date
        let dateString = String(prefixInputDate)
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.timeZone = TimeZone(identifier: "UTC")
        stringDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = stringDateFormatter.date(from: dateString) else {
            return ""
        }
        
        // Time interval between dates
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.day, .year], from: date, to: .now)
        
        guard let dayInterval = interval.day,
              let yearInterval = interval.year else {
            return ""
        }
        
        // Today's message
        if dayInterval == 0 {
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
        
        // Last week's message
        if dayInterval < 6 {
            let dateFormatter = DateFormatter()
            return dateFormatter.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
        }
        
        // Previous years message
        if yearInterval > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            return dateFormatter.string(from: date)
        }
        
        // Far than a week this year message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
}
