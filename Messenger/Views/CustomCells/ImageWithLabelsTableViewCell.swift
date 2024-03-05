//
//  UserSettingsCell.swift
//  Messenger
//
//  Created by e1ernal on 07.02.2024.
//

import UIKit

class ImageWithLabelsTableViewCell: UITableViewCell {
    static let identifier = "ImageWithLabelsTableViewCell"
    
    private lazy var roundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .constant(.imageCornerRadius)
        imageView.image = .assetImage(.addPhoto)
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

        NSLayoutConstraint.activate([
            roundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            roundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            roundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constant(.spacing)),
            roundImageView.heightAnchor.constraint(equalToConstant: .constant(.imageHeight)),
            roundImageView.widthAnchor.constraint(equalToConstant: .constant(.imageHeight)),

            titleLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .constant(.spacing)),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            titleLabel.bottomAnchor.constraint(equalTo: roundImageView.centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: roundImageView.trailingAnchor, constant: .constant(.spacing)),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
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
