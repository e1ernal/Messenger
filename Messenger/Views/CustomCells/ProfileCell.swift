//
//  UserSettingsCell.swift
//  Messenger
//
//  Created by e1ernal on 07.02.2024.
//

import UIKit

class ProfileCell: UITableViewCell {
    static let identifier = "ProfileCell"
    
    private lazy var roundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .const(.imageCornerRadius)
        imageView.image = .systemImage(.addPhoto, color: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = BasicLabel("", .font(.secondaryTitle))
    private let subtitleLabel = BasicLabel("", .font(.subtitle))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        
        contentView.addSubview(roundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        // Lower priority to avoid warnings
        let roundImageViewHeightConstraint = roundImageView.heightAnchor.constraint(equalToConstant: ceil(.const(.imageHeight)))
        roundImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            roundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            roundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            roundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing)),
            roundImageViewHeightConstraint,
            roundImageView.widthAnchor.constraint(equalToConstant: .const(.imageHeight)),

            titleLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .const(.spacing)),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            titleLabel.bottomAnchor.constraint(equalTo: roundImageView.centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .const(.spacing)),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            subtitleLabel.topAnchor.constraint(equalTo: roundImageView.centerYAnchor)
        ])
    }
    
    func configure(image: UIImage, title: String, subtitle: String) {
        roundImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
