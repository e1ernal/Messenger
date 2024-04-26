//
//  NSMutableAttributedString+Extensions.swift
//  Messenger
//
//  Created by e1ernal on 03.01.2024.
//

import Foundation
import UIKit

extension String {
    func leftPadding(toLength: Int, withPad: String) -> String {
        String(String(reversed()).padding(toLength: toLength, withPad: withPad, startingAt: 0).reversed())
    }
    
    // Convert String-UIImage
    func toImage() -> UIImage {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return UIImage()
        }
        return image
    }
    
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
