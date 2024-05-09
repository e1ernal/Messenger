//
//  SymmetricKey.swift
//  Messenger
//
//  Created by e1ernal on 07.05.2024.
//

import CryptoKit
import Foundation

extension SymmetricKey {
    /// Creates a `SymmetricKey` from a Base64-encoded `String`.
    ///
    /// - Parameter base64EncodedString: The Base64-encoded string from which to generate the `SymmetricKey`.
    init(base64EncodedString: String) throws {
        guard let data = Data(base64Encoded: base64EncodedString) else {
            throw DescriptionError.error("Can't init SymmetricKey from Base64")
        }

        self.init(data: data)
    }

    // MARK: - Instance Methods
    /// Serializes a `SymmetricKey` to a Base64-encoded `String`.
    func toString() -> String {
        return self.withUnsafeBytes { Data($0).base64EncodedString() }
    }
    
    func toData() throws -> Data {
        let string = self.withUnsafeBytes { Data($0).base64EncodedString() }
        return try string.toData()
    }
}
