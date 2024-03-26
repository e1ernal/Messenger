//
//  MessageSectionCell.swift
//  Messenger
//
//  Created by e1ernal on 26.03.2024.
//

import UIKit

class MessageSectionCell: UITableViewCell {
    static let identifier = "MessageSectionCell"
    
    private let sectionDateLabel = BasicLabel("", .font(.header))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        sectionDateLabel.textColor = .inactive
        sectionDateLabel.numberOfLines = 0
        sectionDateLabel.textAlignment = .center
        
        contentView.addSubview(sectionDateLabel)
        
        NSLayoutConstraint.activate([
            sectionDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            sectionDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constant(.spacing)),
            sectionDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sectionDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(date: String) {
        sectionDateLabel.text = date
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
