//
//  UITableView+Extension.swift
//  Messenger
//
//  Created by e1ernal on 17.04.2024.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(name: String) {
        let backgroundView = UIView(frame: CGRect(x: self.center.x,
                                                  y: self.center.y,
                                                  width: self.bounds.size.width,
                                                  height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: CGFloat(14), weight: .bold)
        titleLabel.text = "You invited \(name) to join a Chat"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(string: "Chats:\n🔒 Use end-to-end encryption\n🔒 Leave no trace on our servers\n🔒 Do not allow forwarding")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = .const(.halfSpacing)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: CGFloat(13), weight: .regular)
        messageLabel.attributedText = attributedString
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        let bubbleView = UIView()
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = .secondarySystemBackground
        bubbleView.layer.cornerRadius = .const(.cornerRadius)
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = .const(.spacing)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(messageLabel)
        
        backgroundView.addSubview(bubbleView)
        backgroundView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
            
            titleLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            
            bubbleView.topAnchor.constraint(equalTo: stack.topAnchor, constant: -.const(.cornerRadius)),
            bubbleView.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -.const(.cornerRadius)),
            bubbleView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: .const(.cornerRadius)),
            bubbleView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: .const(.cornerRadius))
        ])
        
        self.backgroundView = backgroundView
    }
    
    func restore() { self.backgroundView = nil }
    
    // Scroll to bottom of TableView
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
