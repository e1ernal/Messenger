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
        timeLabel.textColor = .secondaryLabel
        timeLabel.textAlignment = .right
        
        contentView.addSubview(messageBubbleView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        messageLabelLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * .constant(.spacing))
        messageLabelTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .constant(.spacing))
        messageLabelLeadingConstraint?.priority = .defaultHigh
        messageLabelTrailingConstraint?.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing) + .constant(.halfSpacing)),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(.constant(.spacing) + .constant(.halfSpacing))),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: messageLabel.intrinsicContentSize.height),
            
            messageBubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -.constant(.spacing)),
            messageBubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .constant(.spacing))
        ])
        
        messageBubbleView.layer.cornerRadius = cornerRadius
    }
    
    func configure(message: String, side: MessageSide, superViewWidth: CGFloat, time: String) {
        switch side {
        case .left:
            messageLabel.textColor = .label
            timeLabel.textColor = .secondaryLabel
            messageBubbleView.backgroundColor = .backgroundSecondary
            messageLabelLeadingConstraint?.isActive = true
            messageLabelTrailingConstraint?.isActive = false
        case .right:
            messageLabel.textColor = .white
            timeLabel.textColor = .lightText
            messageBubbleView.backgroundColor = .active
            messageLabelLeadingConstraint?.isActive = false
            messageLabelTrailingConstraint?.isActive = true
        }
        
        timeLabel.text = time
        messageLabel.attributedText = NSMutableAttributedString()
            .font(message, .font(.subtitle))
            .highlighted("____", .font(.subtitle), foreground: .clear, background: .clear)
        
        NSLayoutConstraint.activate([
            messageBubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: .constant(.spacing)),
            messageBubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -.constant(.spacing)),
            
            timeLabel.centerYAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
