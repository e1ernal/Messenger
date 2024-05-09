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
    
    func toSecKey() throws -> SecKey {
        guard let data = Data(base64Encoded: self) else {
            throw DescriptionError.error("String to SecKey: Can't convert Base64String to Data")
        }

        let keyDict: [NSObject: NSObject] = [
           kSecAttrKeyType: kSecAttrKeyTypeRSA,
           kSecAttrKeyClass: kSecAttrKeyClassPublic,
           kSecAttrKeySizeInBits: NSNumber(value: 2048),
           kSecReturnPersistentRef: true as NSObject
        ]

        guard let secKey = SecKeyCreateWithData(data as CFData, 
                                                keyDict as CFDictionary,
                                                nil) else {
            throw DescriptionError.error("String to SecKey: Can't convert Data to SecKey")
        }
        return secKey
    }
    
    func toData() throws -> Data {
        guard let messageData = self.data(using: .utf8) else {
            throw DescriptionError.error("String to Data: Can't convert String to Data")
        }
        return messageData
    }
}
