//
//  Storage+Codable.swift
//  Messenger
//
//  Created by e1ernal on 06.03.2024.
//

import Foundation

// MARK: - Encode input object & Decode output objects
extension Storage {
    internal func encode<T: Codable>(_ object: T) throws -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(object)
        } catch {
            throw DescriptionError.error("Can't encode")
        }
    }
    
    internal func decode<T: Decodable>(_ object: Data, as type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: object)
        } catch {
            throw DescriptionError.error("Can't decode")
        }
    }
}
