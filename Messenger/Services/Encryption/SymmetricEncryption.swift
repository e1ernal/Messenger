//
//  SymmetricEncryption.swift
//  Messenger
//
//  Created by e1ernal on 05.05.2024.
//

import CryptoKit
import Foundation

final class SymmetricEncryption {
    static let shared = SymmetricEncryption(); private init() {}

    func generateKey() -> String {
        let symmetricKey = SymmetricKey(size: .bits256)
        return symmetricKey.withUnsafeBytes { Data($0).base64EncodedString() }
    }

    func encrypt(message: String, key: String) throws -> String {
        guard let messageData = message.data(using: .utf8) else {
            throw DescriptionError.error("SymmetricEncryption: Error encryption. Reason: Can't get message data")
        }
        
        guard let keyData = Data(base64Encoded: key) else {
            throw DescriptionError.error("SymmetricEncryption: Error encryption. Reason: Can't get key data")
        }
        
        let symmetricKey = SymmetricKey(data: keyData)
        
        
        let encryptedData = try AES.GCM.seal(messageData, using: symmetricKey)

        guard let encryptedString = encryptedData.combined?.base64EncodedString() else {
            throw DescriptionError.error("SymmetricEncryption: Error encryption. Reason: Can't make String from Data")
        }
        return encryptedString
    }

    func decrypt(message: String, key: String) throws -> String {
        guard let messageData = Data(base64Encoded: message, options: .ignoreUnknownCharacters) else {
            throw DescriptionError.error("SymmetricEncryption: Error decryption. Reason: Can't get message data")
        }
        
        guard let keyData = Data(base64Encoded: key) else {
            throw DescriptionError.error("SymmetricEncryption: Error encryption. Reason: Can't get key data")
        }
        
        let symmetricKey = SymmetricKey(data: keyData)
        
        let sealedBox = try AES.GCM.SealedBox(combined: messageData)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
            throw DescriptionError.error("SymmetricEncryption: Error decryption. Reason: Can't make String from Data")
        }
        
        return decryptedMessage
    }
}
