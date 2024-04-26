//
//  Int+Extension.swift
//  Messenger
//
//  Created by e1ernal on 17.04.2024.
//

import Foundation

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
                                               from: date,
                                               to: .now)
        
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
        let interval = calendar.dateComponents([.day, .year],
                                               from: date,
                                               to: .now)
        
        guard let yearInterval = interval.year,
              let dayInterval = interval.day
        else { return "" }
        
        // Previous years message
        if yearInterval > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        // Today's message
        if dayInterval == 0 { return "Today" }
        
        // This year message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
}
