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
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage.systemImage(.lock)
            .withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            .withTintColor(.label)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSMutableAttributedString()
            .font("You invited \(name) to join a Chat\n", .systemFont(ofSize: CGFloat(14), weight: .bold), .center)
            .font("\nChats:\n", .systemFont(ofSize: CGFloat(13), weight: .regular), .left)
        )
        
        let texts = ["Use end-to-end encryption\n", "Leave no trace on our servers\n", "Do not allow forwarding"]
        for text in texts {
            attributedString.append(imageString)
            attributedString.append(NSMutableAttributedString()
                .font("  \(text)", .systemFont(ofSize: CGFloat(13), weight: .regular), .left)
            )
            attributedString.addAttribute(.baselineOffset,
                                          value: 2,
                                          range: NSRange(location: attributedString.length - text.count, length: text.count))
        }
        
        let attributedLabel = UILabel()
        attributedLabel.attributedText = attributedString
        attributedLabel.numberOfLines = 0
        attributedLabel.isUserInteractionEnabled = true
        attributedLabel.translatesAutoresizingMaskIntoConstraints = false

        let bubbleView = UIView()
        bubbleView.backgroundColor = .secondarySystemFill
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = .const(.cornerRadius)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.addSubview(attributedLabel)
        backgroundView.addSubview(bubbleView)

        NSLayoutConstraint.activate([
            attributedLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            attributedLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            attributedLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),

            bubbleView.topAnchor.constraint(equalTo: attributedLabel.topAnchor, constant: -.const(.cornerRadius)),
            bubbleView.leadingAnchor.constraint(equalTo: attributedLabel.leadingAnchor, constant: -.const(.cornerRadius)),
            bubbleView.trailingAnchor.constraint(equalTo: attributedLabel.trailingAnchor, constant: .const(.cornerRadius)),
            bubbleView.bottomAnchor.constraint(equalTo: attributedLabel.bottomAnchor, constant: .const(.cornerRadius))
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
