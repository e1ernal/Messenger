//
//  ImageTableViewCell.swift
//  Messenger
//
//  Created by e1ernal on 11.02.2024.
//

import UIKit

class SquareImageCell: UITableViewCell {
    static let identifier = "SquareImageCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = .assetImage(.addPhoto)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoImageView)
        backgroundColor = .clear
        
        // Lower priority to avoid warnings
        let photoImageViewHeightConstraint = photoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        photoImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photoImageViewHeightConstraint
        ])
    }
    
    func configure(image: UIImage?) {
        if let image { photoImageView.image = image }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
