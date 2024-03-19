//
//  Image.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import UIKit

enum Image: String {
    // MARK: - System Images
    case warning = "exclamationmark.circle"
    case number = "number.circle"
    case info = "info.circle"
    case expand = "arrow.down.left.and.arrow.up.right.circle.fill"
    case optionsLines = "line.horizontal.3"
    case optionsDots = "ellipsis"
    case delete = "trash"
    case logOut = "rectangle.portrait.and.arrow.right"
    case rightArrow = "chevron.right"
    case chats = "ellipsis.message.fill"
    case settings = "gear"
    case edit = "square.and.pencil"
    case sendMessage = "paperplane"
    case sendButton = "arrowshape.up.circle.fill"
    case clip = "paperclip.circle"
    
    // MARK: - Assets Images
    case addPhoto = "addPhoto"
}

extension UIImage {
    static func assetImage(_ name: Image) -> UIImage {
        guard let image = UIImage(named: name.rawValue) else {
            return UIImage()
        }
        return image
    }
    
    static func systemImage(_ name: Image, color: UIColor?) -> UIImage {
        guard let image = UIImage(systemName: name.rawValue) else {
            return UIImage()
        }
        
        guard let color else {
            return image.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        }
        
        return image.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
