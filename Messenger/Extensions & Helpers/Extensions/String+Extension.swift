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

extension Int {
    func toDate() -> Date {
        let myTimeInterval = TimeInterval(self)
        return NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval)) as Date
    }
    
    func toDateWithoutTime() -> Date {
        let date = self.toDate()
        
        guard let dateWithoutTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day],
                                                                                                from: date))
        else { return date }
        
        return dateWithoutTime
    }
    
    func toChatDate() -> String {
        let date = self.toDate()
        
        // Time interval between dates
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.day, .year], 
                                               from: date, to: .now)
        
        guard let dayInterval = interval.day,
              let yearInterval = interval.year else {
            return ""
        }
        
        // Today's message
        if dayInterval == 0 {
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
    
    func toTime() -> String {
        let date = self.toDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func toSectionDate() -> String {
        let date = self.toDate()
        
        // Time interval between dates
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.year], from: date, to: .now)
        
        guard let yearInterval = interval.year else { return "" }
        
        // Previous years message
        if yearInterval > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        // This year message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
}

extension String {
    func withoutTime() -> String {
        return String(self.prefix { $0 != "." })
    }
    
    func toDate(format: String) throws -> Date {
        let prefixInputDate = self.prefix { $0 != "." }
        
        // Convert String to Date
        let dateString = String(prefixInputDate)
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.timeZone = TimeZone(identifier: "UTC")
        stringDateFormatter.dateFormat = format
        
        guard let date = stringDateFormatter.date(from: dateString) else {
            throw DescriptionError.error("Can't convert string to date")
        }
        
        return date
    }
    
    func toChatDate() -> String {
        var date: Date?
        
        do { date = try self.toDate(format: "yyyy-MM-dd HH:mm:ss")
        } catch { print(error) }
        
        guard let date else { return "" }
        
        // Time interval between dates
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.day, .year], from: date, to: .now)
        
        guard let dayInterval = interval.day,
              let yearInterval = interval.year else {
            return ""
        }
        
        // Today's message
        if dayInterval == 0 {
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
    
    func toMessageTime() -> String {
        var date: Date?
        
        do { date = try self.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")
        } catch { print(error) }
        
        guard let date else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func toMessageDate() -> String {
        var date: Date?
        
        do { date = try self.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")
        } catch { print(error) }
        
        guard let date else { return "" }
        
        // Time interval between dates
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.year], from: date, to: .now)
        
        guard let yearInterval = interval.year else { return "" }
        
        // Previous years message
        if yearInterval > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        // This year message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
}

extension String {
    func numberFormatter() -> String {
        let mask = "+X (XXX) XXX-XXXX"
        let number = self.replacingOccurrences(of: "[^0-9]",
                                               with: "",
                                               options: .regularExpression)
        var result: String = ""
        var index = number.startIndex
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else { result.append(character) }
        }
        return result
    }
}
