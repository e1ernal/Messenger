//
//  MessageCell.swift
//  Messenger
//
//  Created by e1ernal on 19.03.2024.
//

import UIKit

class MessageCell: UITableViewCell {
    static let identifier = "MessageCell"
    
    private let messageLabel = BasicLabel("Message", .font(.subtitle))
    private let timeLabel = BasicLabel("", .font(.mini))
    private let maxCornerRadius: Double
    private let minCornerRadius: Double
    
    private let messageBubble: BubbleView = {
        let view = BubbleView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .active
        view.side = .right
        return view
    }()
    
    var messageLabelLeadingConstraint: NSLayoutConstraint?
    var messageLabelTrailingConstraint: NSLayoutConstraint?
    var messageLabelTopMaxConstraint: NSLayoutConstraint?
    var messageLabelTopMinConstraint: NSLayoutConstraint?
    var messageLabelBottomMaxConstraint: NSLayoutConstraint?
    var messageLabelBottomMinConstraint: NSLayoutConstraint?
    
    var messageBubbleTopConstraint: NSLayoutConstraint?
    var messageBubbleBottomConstraint: NSLayoutConstraint?
    var messageBubbleLeadingConstraint: NSLayoutConstraint?
    var messageBubbleTrailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        maxCornerRadius = (messageLabel.intrinsicContentSize.height + 2 * .const(.spacing)) * 0.25
        minCornerRadius = maxCornerRadius * 0.5
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .secondaryLabel
        timeLabel.textAlignment = .right
        
        contentView.addSubview(messageBubble)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        messageLabelLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                                              constant: 2 * .const(.spacing))
        messageLabelTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                                constant: -2 * .const(.spacing))
        messageLabelTopMaxConstraint = messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                                         constant: .const(.spacing) + .const(.halfSpacing))
        messageLabelTopMinConstraint = messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                                         constant: .const(.spacing) + 1)
        messageLabelBottomMaxConstraint = messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                               constant: -(.const(.spacing) + .const(.halfSpacing)))
        messageLabelBottomMinConstraint = messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                               constant: -(.const(.spacing) + 1))
        
        messageLabelLeadingConstraint?.priority = .defaultHigh
        messageLabelTrailingConstraint?.priority = .defaultHigh
        messageLabelTopMaxConstraint?.priority = .defaultHigh
        messageLabelTopMinConstraint?.priority = .defaultHigh
        messageLabelBottomMaxConstraint?.priority = .defaultHigh
        messageLabelBottomMinConstraint?.priority = .defaultHigh
        
        messageBubbleTopConstraint = messageBubble.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -.const(.spacing))
        messageBubbleBottomConstraint = messageBubble.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .const(.spacing))
        messageBubbleLeadingConstraint = messageBubble.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: .const(.spacing))
        messageBubbleTrailingConstraint = messageBubble.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -.const(.spacing))
        
        messageBubbleTopConstraint?.priority = .defaultHigh
        messageBubbleBottomConstraint?.priority = .defaultHigh
        messageBubbleLeadingConstraint?.priority = .defaultHigh
        messageBubbleTrailingConstraint?.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: messageLabel.intrinsicContentSize.height)
        ])
    }
    
    func configure(message: String,
                   side: Side,
                   roundType: RoundType,
                   superViewWidth: CGFloat,
                   time: String) {
        switch side {
        case .left:
            messageLabel.textColor = .label
            timeLabel.textColor = .secondaryLabel
            messageLabelLeadingConstraint?.isActive = true
            messageLabelTrailingConstraint?.isActive = false
            messageBubble.backgroundColor = .backgroundSecondary
            
        case .right:
            messageLabel.textColor = .white
            timeLabel.textColor = .lightText
            messageLabelLeadingConstraint?.isActive = false
            messageLabelTrailingConstraint?.isActive = true
            messageBubble.backgroundColor = .active
        }
        
        timeLabel.text = time
        messageLabel.attributedText = NSMutableAttributedString()
            .font(message, .font(.subtitle))
            .highlighted("____",
                         .font(.subtitle),
                         foreground: .clear,
                         background: .clear)
        
        messageBubbleTopConstraint?.isActive = true
        messageBubbleBottomConstraint?.isActive = true
        messageBubbleLeadingConstraint?.isActive = true
        messageBubbleTrailingConstraint?.isActive = true
        messageBubble.side = side
        messageBubble.roundType = roundType
        
        switch roundType {
        case .start:
            messageLabelTopMaxConstraint?.isActive = true
            messageLabelBottomMinConstraint?.isActive = true
            
            messageLabelTopMinConstraint?.isActive = false
            messageLabelBottomMaxConstraint?.isActive = false
        case .between:
            messageLabelTopMinConstraint?.isActive = true
            messageLabelBottomMinConstraint?.isActive = true
            
            messageLabelTopMaxConstraint?.isActive = false
            messageLabelBottomMaxConstraint?.isActive = false
        case .end:
            messageLabelTopMinConstraint?.isActive = true
            messageLabelBottomMaxConstraint?.isActive = true
            
            messageLabelTopMaxConstraint?.isActive = false
            messageLabelBottomMinConstraint?.isActive = false
        case .startEnd:
            messageLabelTopMaxConstraint?.isActive = true
            messageLabelBottomMaxConstraint?.isActive = true
            
            messageLabelTopMinConstraint?.isActive = false
            messageLabelBottomMinConstraint?.isActive = false
        }
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
