//
//  ChatCell.swift
//  Messenger
//
//  Created by e1ernal on 07.03.2024.
//

import UIKit

class ChatCell: UITableViewCell {
    static let identifier = "ChatCell"
    
    private lazy var roundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .const(.chatImageCornerRadius)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    private let nameLabel = BasicLabel("", .font(.subtitleBold))
    private let messageLabel = BasicLabel("", .font(.subtitle))
    private let dateLabel = BasicLabel("", .font(.body))
    
    private var messageLabelBottomConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.textAlignment = .left
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 1
        
        messageLabel.textAlignment = .left
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
        
        contentView.addSubview(roundImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)

        // Lower priority to avoid warnings
        let roundImageViewHeightConstraint = roundImageView.heightAnchor.constraint(equalToConstant: ceil(.const(.chatImageHeight)))
        roundImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            roundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            roundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            roundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing)),
            roundImageViewHeightConstraint,
            roundImageView.widthAnchor.constraint(equalToConstant: .const(.chatImageHeight)),

            nameLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .const(.spacing)),
            nameLabel.topAnchor.constraint(equalTo: roundImageView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -.const(.spacing)),
            
            messageLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .const(.spacing)),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        messageLabelBottomConstraint = messageLabel.bottomAnchor.constraint(equalTo: roundImageView.bottomAnchor)
        messageLabelBottomConstraint?.isActive = true
    }
    
    func configure(image: UIImage, name: String, message: String?, date: String?) {
        roundImageView.image = image
        nameLabel.text = name
        messageLabel.text = message ?? ""
        dateLabel.text = date ?? ""
        
        if messageLabel.actualNumberOfLines == 1 {
            messageLabelBottomConstraint?.isActive = false
            messageLabel.numberOfLines = 1
        } else {
            messageLabelBottomConstraint?.isActive = true
            messageLabel.numberOfLines = 2
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
