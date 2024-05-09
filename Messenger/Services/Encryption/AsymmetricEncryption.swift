//
//  Crypto.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import Foundation
import Security

final class AsymmetricEncryption {
    static let shared = AsymmetricEncryption(); private init() {}
    
    func generateKeys() throws -> (publicKey: String, privateKey: String) {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048
        ]
        
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error generating keys. Reason: Can't create private key")
        }
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw DescriptionError.error("AsymmetricEncryption: Error generating keys. Reason: Can't create public key")
        }
        
        guard let publicKeyCFData = SecKeyCopyExternalRepresentation(publicKey, nil),
              let privateKeyCFData = SecKeyCopyExternalRepresentation(privateKey, nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error generating keys. Reason: Can't make key CFData")
        }
        let publicKeyString = (publicKeyCFData as Data).base64EncodedString()
        let privateKeyString = (privateKeyCFData as Data).base64EncodedString()
        return (publicKeyString, privateKeyString)
    }
    
    func encrypt(message: String, publicKey: String) throws -> String {
        guard let messageData = message.data(using: .utf8) else {
            throw DescriptionError.error("AsymmetricEncryption: Error encryption. Reason: Can't get message data")
        }
        
        guard let publicKeyData = Data(base64Encoded: publicKey) else {
            throw DescriptionError.error("AsymmetricEncryption: Error encryption. Reason: Can't get key data")
        }
        
        let attributes: [NSObject: NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: 2048),
            kSecReturnPersistentRef: true as NSObject
        ]
        
        guard let publicSecKey = SecKeyCreateWithData(publicKeyData as CFData, attributes as CFDictionary, nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error encryption. Reason: Can't make SecKey from key data")
        }
        
        guard let encryptedMessageCFData = SecKeyCreateEncryptedData(publicSecKey,
                                                                     .rsaEncryptionPKCS1,
                                                                     messageData as CFData,
                                                                     nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error encryption. Reason: Can't encrypt data")
        }
        
        return (encryptedMessageCFData as Data).base64EncodedString()
    }
    
    func decrypt(message: String, privateKey: String) throws -> String {
        guard let encryptedMessageData = Data(base64Encoded: message, options: .ignoreUnknownCharacters) else {
            throw DescriptionError.error("AsymmetricEncryption: Error decryption. Reason: Can't get message data")
        }
        
        guard let privateKeyData = Data(base64Encoded: privateKey) else {
            throw DescriptionError.error("AsymmetricEncryption: Error decryption. Reason: Can't get key data")
        }
        
        let attributes: [NSObject: NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits: NSNumber(value: 2048),
            kSecReturnPersistentRef: true as NSObject
        ]
        
        guard let privateSecKey = SecKeyCreateWithData(privateKeyData as CFData, attributes as CFDictionary, nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error decryption. Reason: Can't make SecKey from key data")
        }
        
        guard let decryptedMessageCFData = SecKeyCreateDecryptedData(privateSecKey,
                                                                     .rsaEncryptionPKCS1,
                                                                     encryptedMessageData as CFData,
                                                                     nil) else {
            throw DescriptionError.error("AsymmetricEncryption: Error decryption. Reason: Can't decrypt data")
        }
        
        guard let decryptedMessage = String(data: decryptedMessageCFData as Data, encoding: .utf8) else {
            throw DescriptionError.error("AsymmetricEncryption: Error decryption. Reason: Can't make String from Data")
        }
        return decryptedMessage
    }
}
