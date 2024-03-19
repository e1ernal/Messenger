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
    
    private let messageLabel = BasicLabel("", .font(.subtitle))
    private let timeLabel = BasicLabel("", .font(.mini))
    
    private let messageBubbleView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = .constant(.spacing)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .inactive
        
        contentView.addSubview(messageBubbleView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2 * .constant(.spacing)),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2 * .constant(.spacing)),
            
            messageBubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -.constant(.spacing)),
            messageBubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .constant(.spacing)),
            
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.topAnchor.constraint(equalTo: messageBubbleView.bottomAnchor)
        ])
    }
    
    func configure(message: String, side: MessageSide, superViewWidth: CGFloat, time: String) {
        messageLabel.text = message
        timeLabel.text = time
        
        let maxWidth = superViewWidth * 0.8
        let messageSize = (message as NSString).size()
        let optimalWidth = messageSize.width < maxWidth ? messageLabel.intrinsicContentSize.width : maxWidth

        switch side {
        case .left:
            timeLabel.textAlignment = .left
            messageLabel.textColor = .label
            messageBubbleView.backgroundColor = .backgroundSecondary
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * .constant(.spacing)).isActive = true
        case .right:
            timeLabel.textAlignment = .right
            messageLabel.textColor = .white
            messageBubbleView.backgroundColor = .active
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .constant(.spacing)).isActive = true
        }
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalToConstant: optimalWidth),
            messageBubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -.constant(.spacing)),
            messageBubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: .constant(.spacing)),
            
            timeLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: .constant(.spacing)),
            timeLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -.constant(.spacing))
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
