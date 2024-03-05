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

class ImageWithButtonTableViewCell: UITableViewCell {
    static let identifier = "ImageWithButtonTableViewCell"
    
    weak var cellDelegate: SetNewPhotoDelegate?
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .constant(.doubleHeight) * 0.5
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
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            photoImageView.heightAnchor.constraint(equalToConstant: .constant(.doubleHeight)),
            photoImageView.widthAnchor.constraint(equalToConstant: .constant(.doubleHeight)),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            newPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            newPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing)),
            newPhotoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newPhotoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: .constant(.spacing))
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
