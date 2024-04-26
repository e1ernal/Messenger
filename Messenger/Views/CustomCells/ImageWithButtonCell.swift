//
//  ImageWithButtonTableViewCell.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

protocol SetNewPhotoDelegate: AnyObject {
    func setNewPhoto()
}

class ImageWithButtonCell: UITableViewCell {
    static let identifier = "ImageWithButtonCell"
    
    weak var cellDelegate: SetNewPhotoDelegate?
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .const(.doubleHeight) * 0.5
        imageView.image = .assetImage(.addPhoto)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var newPhotoButton = BasicButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        newPhotoButton = BasicButton(title: "", style: .clear(.active)) {
            self.actionButton()
        }
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(newPhotoButton)
        backgroundColor = .clear
        
        // Lower priority to avoid warnings
        let photoImageViewHeightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: .const(.doubleHeight))
        photoImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            photoImageViewHeightConstraint,
            photoImageView.widthAnchor.constraint(equalToConstant: .const(.doubleHeight)),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            newPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            newPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            newPhotoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newPhotoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: .const(.spacing))
        ])
    }
    
    func actionButton() {
        cellDelegate?.setNewPhoto()
    }
    
    func configure(image: UIImage, text: String, delegate: SetNewPhotoDelegate) {
        photoImageView.image = image
        newPhotoButton.configure(title: text)
        cellDelegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
