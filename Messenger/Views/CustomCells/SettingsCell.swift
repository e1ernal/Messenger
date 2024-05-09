//
//  SettingsCell.swift
//  Messenger
//
//  Created by e1ernal on 09.05.2024.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let identifier = "SettingsCell"
    
    private lazy var settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let settingsLabel = BasicLabel("", .font(.subtitle))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        settingsLabel.textAlignment = .left
        settingsLabel.textColor = .label
        settingsLabel.numberOfLines = 1
        
        contentView.addSubview(settingsImageView)
        contentView.addSubview(settingsLabel)

        // Lower priority to avoid warnings
        let settingsImageViewHeightConstraint = settingsImageView.heightAnchor.constraint(equalToConstant: ceil(.const(.doubleSpacing)))
        settingsImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            settingsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            settingsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            settingsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing)),
            settingsImageView.widthAnchor.constraint(equalToConstant: .const(.doubleSpacing)),
            settingsImageViewHeightConstraint,

            settingsLabel.leadingAnchor.constraint(equalTo: settingsImageView.trailingAnchor, constant: .const(.spacing)),
            settingsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            settingsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            settingsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        accessoryType = .disclosureIndicator
        self.separatorInset = UIEdgeInsets(top: 0, left: .const(.doubleSpacing) + 2 * .const(.spacing), bottom: 0, right: 0)
    }
    
    func configure(image: UIImage, text: String) {
        settingsImageView.image = image.withTintColor(.label)
        settingsLabel.text = text
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
