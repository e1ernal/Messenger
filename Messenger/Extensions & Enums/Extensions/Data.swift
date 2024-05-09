//
//  Data+Extension.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, 
                                                 encoding: String.Encoding.utf8.rawValue) 
        else { return nil }
        
        return prettyPrintedString
    }
    
    func toString() throws -> String {
        guard let string = String(data: self, encoding: .utf8) else {
            throw DescriptionError.error("Convert Data to String")
        }
        return string
    }
    
    func toSecKey() throws -> SecKey {
        let options: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic
        ]
        
        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(self as CFData,
                                                options as CFDictionary,
                                                &error) else {
            if let error { throw error.takeRetainedValue() as Error
            } else { throw DescriptionError.error("Convert Data to SecKey") }
        }
        
        return secKey
    }
}
