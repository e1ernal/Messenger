//
//  UserSearchResults.swift
//  Messenger
//
//  Created by e1ernal on 23.02.2024.
//

import UIKit

class SearchResultsCell: UITableViewCell {
    static let identifier = "SearchResultsCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .constant(.height) / 2
        imageView.image = .assetImage(.addPhoto)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private let nameLabel = BasicLabel("Name", .font(.subtitleBold))
    private let usernameLabel = BasicLabel("@username", .font(.body))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .active
        usernameLabel.numberOfLines = 1
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)

        // Lower priority to avoid warnings
        let photoImageViewHeightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: .constant(.height))
        photoImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constant(.spacing)),
            photoImageViewHeightConstraint,
            photoImageView.widthAnchor.constraint(equalToConstant: .constant(.height)),

            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: .constant(.spacing)),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            nameLabel.bottomAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: .constant(.spacing)),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            usernameLabel.topAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
        ])
    }
    
    func setupCell(image: UIImage, name: String, username: String) {
        photoImageView.image = image
        nameLabel.text = name
        usernameLabel.text = "@" + username
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
