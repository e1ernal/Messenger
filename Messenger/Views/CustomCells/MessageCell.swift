//
//  MessageCell.swift
//  Messenger
//
//  Created by e1ernal on 19.03.2024.
//

import UIKit

enum MessageSide {
    case left
    case right
}

class MessageCell: UITableViewCell {
    static let identifier = "MessageCell"
    
    private let messageLabel = BasicLabel("Message", .font(.subtitle))
    private let timeLabel = BasicLabel("", .font(.mini))
    private let cornerRadius: Double
    
    private let messageBubbleView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var messageLabelLeadingConstraint: NSLayoutConstraint?
    var messageLabelTrailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cornerRadius = (messageLabel.intrinsicContentSize.height + 2 * .constant(.spacing)) * 0.5
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .inactive
        
        contentView.addSubview(messageBubbleView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        messageLabelLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * .constant(.spacing))
        messageLabelTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .constant(.spacing))
        messageLabelLeadingConstraint?.priority = .defaultHigh
        messageLabelTrailingConstraint?.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2 * .constant(.spacing)),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2 * .constant(.spacing)),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: messageLabel.intrinsicContentSize.height),
            
            messageBubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -.constant(.spacing)),
            messageBubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .constant(.spacing)),
            
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.topAnchor.constraint(equalTo: messageBubbleView.bottomAnchor)
        ])
        
        messageBubbleView.layer.cornerRadius = cornerRadius
    }
    
    func configure(message: String, side: MessageSide, superViewWidth: CGFloat, time: String) {
        messageLabel.text = message
        timeLabel.text = time
        
        switch side {
        case .left:
            timeLabel.textAlignment = .left
            messageLabel.textColor = .label
            messageBubbleView.backgroundColor = .backgroundSecondary
            messageLabelLeadingConstraint?.isActive = true
            messageLabelTrailingConstraint?.isActive = false
            timeLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: .constant(.spacing)).isActive = true
        case .right:
            timeLabel.textAlignment = .right
            messageLabel.textColor = .white
            messageBubbleView.backgroundColor = .active
            messageLabelLeadingConstraint?.isActive = false
            messageLabelTrailingConstraint?.isActive = true
            timeLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -.constant(.spacing)).isActive = true
        }
        
        NSLayoutConstraint.activate([
            messageBubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: .constant(.spacing)),
            messageBubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -.constant(.spacing))
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
