//
//  Row.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import Foundation

enum Row {
    case emptyRow
    case textFieldRow(placeholder: String, text: String)
    case doubleLabelRow(left: String, right: String)
    case regularRow(text: String)
    case imageDoubleLabelRow(image: String, top: String, bottom: String)
    case imageRow(image: String)
    case imageWithButtonRow(image: String, buttonText: String)
    case chatRow(image: String, name: String, message: String, date: String, chatId: String)
    case settingsRow(image: String, text: String, detailedText: String = "")
    
    func getValue() -> [String: String] {
        switch self {
        case .emptyRow:
            return [:]
        case let .textFieldRow(placeholder, text):
            return ["placeholder": placeholder, "text": text]
        case let .doubleLabelRow(left, right):
            return ["left": left, "right": right]
        case let .regularRow(text):
            return ["text": text]
        case let .imageDoubleLabelRow(image, top, bottom):
            return ["image": image, "top": top, "bottom": bottom]
        case let .imageRow(image):
            return ["image": image]
        case let .imageWithButtonRow(image, buttonText):
            return ["image": image, "buttonText": buttonText]
        case let .chatRow(image, name, message, date, chatId):
            return ["image": image, "name": name, "message": message, "date": date, "chatId": chatId]
        case let .settingsRow(image: image, text: text, detailedText: detailedText):
            return ["image": image, "text": text, "detailedText": detailedText]
        }
    }
}
