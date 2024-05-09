//
//  UIImage+Extension.swift
//  Messenger
//
//  Created by e1ernal on 17.04.2024.
//

import Foundation
import UIKit

extension UIImage {
    func toString() -> String {
        let data = self.pngData()
        guard let stringImage = data?.base64EncodedString(options: .endLineWithLineFeed) 
        else { return "" }
        return stringImage
    }
    
    static func assetImage(_ name: Image) -> UIImage {
        guard let image = UIImage(named: name.rawValue) else {
            return UIImage()
        }
        return image
    }
    
    static func systemImage(_ name: Image, color: UIColor? = .inactive) -> UIImage {
        guard let image = UIImage(systemName: name.rawValue) else {
            return UIImage()
        }
        
        guard let color else {
            return image.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        }
        
        return image.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
