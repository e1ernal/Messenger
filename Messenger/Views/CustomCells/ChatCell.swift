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
        imageView.layer.cornerRadius = .constant(.chatImageCornerRadius)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

        // Lower priority to avoid warnings
        let roundImageViewHeightConstraint = roundImageView.heightAnchor.constraint(equalToConstant: ceil(.constant(.chatImageHeight)))
        roundImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            roundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            roundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            roundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constant(.spacing)),
            roundImageViewHeightConstraint,
            roundImageView.widthAnchor.constraint(equalToConstant: .constant(.chatImageHeight)),

            nameLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .constant(.spacing)),
            nameLabel.topAnchor.constraint(equalTo: roundImageView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -.constant(.spacing)),
            
            messageLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .constant(.spacing)),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing))
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

extension UILabel {
    var actualNumberOfLines: Int {
        guard let text = self.text else {
            return 0
        }
        layoutIfNeeded()
        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font as Any],
            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
}
