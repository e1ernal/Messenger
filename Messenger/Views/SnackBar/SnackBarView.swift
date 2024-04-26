//
//  SnackBarView.swift
//  Messenger
//
//  Created by e1ernal on 09.02.2024.
//

import Foundation
import UIKit

class SnackBarView: UIView {
    let viewModel: SnackBarViewModel
    
    private let label: BasicLabel = {
        let label = BasicLabel("", .font(.body))
        label.textAlignment = .left
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(viewModel: SnackBarViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        addSubview(label)
        
        if viewModel.image != nil {
            addSubview(imageView)
        }
        
        backgroundColor = .backgroundSecondary
        clipsToBounds = true
        layer.cornerRadius = .const(.cornerRadius)
        layer.masksToBounds = true
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.text = viewModel.text
        imageView.image = viewModel.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if viewModel.image != nil {
            imageView.frame = CGRect(x: .const(.spacing),
                                     y: .const(.spacing),
                                     width: frame.height - 2 * .const(.spacing),
                                     height: frame.height - 2 * .const(.spacing))
            label.frame = CGRect(x: imageView.frame.size.width + 2 * .const(.spacing),
                                 y: .const(.spacing),
                                 width: frame.size.width - imageView.frame.size.width - 3 * .const(.spacing),
                                 height: frame.height - 2 * .const(.spacing))
        } else {
            label.frame = bounds
        }
    }
}
