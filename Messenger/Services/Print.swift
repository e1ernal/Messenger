//
//  Print.swift
//  Messenger
//
//  Created by e1ernal on 08.05.2024.
//

import Foundation
import UIKit

/// Printing of various objects
public enum Print {
    /// It is used for convenient and structured error localised description printing
    /// - Parameters:
    ///   - screen: UIViewController
    ///   - action: UIViewController's method that throws an error
    ///   - reason: Error
    ///   - show: Show to user or not
    public static func error(screen: UIViewController, action: String, reason: Error, show: Bool) {
        print("""
              Error:
              - Screen: \(type(of: screen)),
              - Action: \(action),
              - Reason: \(reason.localizedDescription).
              """)
        if show {
            screen.showSnackBar(text: reason.localizedDescription,
                                image: .systemImage(.warning, color: nil),
                                on: screen)
        }
    }
    
    /// It is used for convenient and structured VC's information printing
    /// - Parameters:
    ///   - screen: UIViewController
    ///   - action: UIViewController's method that throws an error
    ///   - reason: Dictionary to print extra fields
    ///   - show: Show to user or not
    public static func info(screen: UIViewController, action: String, reason: [String: String], show: Bool) {
        print("""
              Information:
              - Screen: \(type(of: screen)),
              - Action: \(action),
              """)
        reason.forEach { print("- \($0): \($1),") }
        if show {
            screen.showSnackBar(text: "\(String(describing: reason.first?.key)): \(String(describing: reason.first?.value))",
                                image: .systemImage(.warning, color: nil),
                                on: screen)
        }
    }
    
    public static func objectInfo<T: Codable>(object: T, spacer: String = "") -> String {
        var info = ""
        for (property, value) in Mirror(reflecting: object).children {
            var valueString = String(describing: value)
            if valueString.count > 10 { valueString = valueString.prefix(20) + "..." }
            info.append("\n\(spacer)\(property ?? "-"): \(valueString)")
        }
        var objectString = String(describing: object)
        if objectString.count > 10 { objectString = objectString.prefix(20) + "..." }
        if info.isEmpty { info += objectString}
        return info
    }
}
