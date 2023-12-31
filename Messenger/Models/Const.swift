//
//  Constraints.swift
//  Messenger
//
//  Created by e1ernal on 17.12.2023.
//

import Foundation
import UIKit

// TODO: - Раскидать по разным ENUM
/// Global constants
final class Const {
    /// Constraints for LayoutConstraint
    struct Constraint {
        static let height: CGFloat = 40.0
        static let width: CGFloat = 10.0
        static let spacing: CGFloat = 10.0
    }
    /// Colors for View elements
    struct Color {
        static let primaryBackground: UIColor = .systemBackground
        static let secondaryBackground: UIColor = .systemGray6
        static let primaryTransparentBackground: UIColor = primaryBackground.withAlphaComponent(0.5)
        static let active: UIColor = .systemBlue.withAlphaComponent(1.0)
        static let inactive: UIColor = .systemGray.withAlphaComponent(0.5)
        static let completed: UIColor = .systemGreen.withAlphaComponent(1.0)
        static let wrong: UIColor = .systemRed.withAlphaComponent(1.0)
    }
    /// Sizes for Fonts
    struct Font {
        static let large: UIFont = .systemFont(ofSize: CGFloat(70), weight: .heavy)
        static let title: UIFont = .systemFont(ofSize: CGFloat(25), weight: .bold)
        static let subtitle: UIFont = .systemFont(ofSize: CGFloat(15), weight: .regular)
        static let button: UIFont = .systemFont(ofSize: CGFloat(15), weight: .semibold)
        static let body: UIFont = .systemFont(ofSize: CGFloat(13), weight: .regular)
    }
}

// TODO: - разобраться с названиями констрейнтов
enum Constant: CGFloat {
    case height = 40.0
    case width = 10.0
    case spacing = 10.1
}

// TODO: - разобраться со значениями цветов
// enum Color: UIColor {
//    case primaryBackground = UIColor.systemBackground
//    case secondaryBackground = .systemGray6
//    case primaryTransparentBackground = primaryBackground.withAlphaComponent(0.5)
//    case active = .systemBlue.withAlphaComponent(1.0)
//    case inactive = .systemGray.withAlphaComponent(0.5)
// }

// TODO: - разобраться со значениями шрифта
// enum Font: UIFont {
//    case large = .systemFont(ofSize: CGFloat(70), weight: .heavy)
//    case title = .systemFont(ofSize: CGFloat(25), weight: .bold)
//    case subtitle = .systemFont(ofSize: CGFloat(15), weight: .regular)
//    case button = .systemFont(ofSize: CGFloat(15), weight: .semibold)
//    case body = .systemFont(ofSize: CGFloat(13), weight: .regular)
// }
