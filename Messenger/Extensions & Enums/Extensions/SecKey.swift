//
//  SecKey.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import Foundation

extension SecKey {
    func toString() throws -> String {
        var error: Unmanaged<CFError>?
        guard let cfdata = SecKeyCopyExternalRepresentation(self, &error) else {
            throw DescriptionError.error("Can't convert SecKey to String")
        }
        let data: Data = cfdata as Data
        return data.base64EncodedString()
    }
}
