//
//  CodableImage.swift
//  Messenger
//
//  Created by e1ernal on 25.04.2024.
//

import Foundation
import UIKit

@propertyWrapper
public struct CodableImage: Codable {
    var image: UIImage
    
    public enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.image,
                                                   in: container,
                                                   debugDescription: "Decoding image failed")
        }
        
        self.image = image
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = image.pngData()
        try container.encode(data, forKey: CodingKeys.image)
    }
    
    public init(wrappedValue: UIImage) {
        self.init(image: wrappedValue)
    }
    
    public var wrappedValue: UIImage {
        get { image }
        set { image = newValue }
    }
}
