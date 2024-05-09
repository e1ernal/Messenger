//
//  DetailedCell.swift
//  Messenger
//
//  Created by e1ernal on 09.05.2024.
//

import UIKit

class DetailedCell: UITableViewCell {
    static let identifier = "DetailedCell"
    
    private lazy var settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = BasicLabel("", .font(.subtitle))
    private let detailedLabel = BasicLabel("", .font(.subtitle))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(settingsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailedLabel)

        // Lower priority to avoid warnings
        let settingsImageViewHeightConstraint = settingsImageView.heightAnchor.constraint(equalToConstant: ceil(.const(.doubleSpacing)))
        settingsImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            settingsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            settingsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            settingsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing)),
            settingsImageView.widthAnchor.constraint(equalToConstant: .const(.doubleSpacing)),
            settingsImageViewHeightConstraint,

            titleLabel.leadingAnchor.constraint(equalTo: settingsImageView.trailingAnchor, constant: .const(.spacing)),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: detailedLabel.leadingAnchor),
            
            detailedLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .const(.spacing)),
            detailedLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing))
        ])
        detailedLabel.textColor = .inactive
        detailedLabel.textAlignment = .right
        
        accessoryType = .disclosureIndicator
        self.separatorInset = UIEdgeInsets(top: 0, left: .const(.doubleSpacing) + 2 * .const(.spacing), bottom: 0, right: 0)
    }
    
    func configure(image: UIImage, titleText: String, detailText: String) {
        settingsImageView.image = image.withTintColor(.label)
        titleLabel.text = titleText
        detailedLabel.text = detailText
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
