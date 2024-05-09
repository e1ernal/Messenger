//
//  DoubleDetailTableViewCell.swift
//  Messenger
//
//  Created by e1ernal on 10.02.2024.
//

import Foundation

import UIKit

class DoubleLabelCell: UITableViewCell {
    static let identifier = "DoubleLabelTableViewCell"
    
    private let leftLabel = BasicLabel("", .font(.body))
    private let rightLabel = BasicLabel("", .font(.button))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.textAlignment = .left
        leftLabel.numberOfLines = 1
        leftLabel.textColor = .secondaryLabel
        
        rightLabel.textAlignment = .right
        rightLabel.textColor = .label
        rightLabel.numberOfLines = 1
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)

        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .const(.spacing)),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing)),
            leftLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            rightLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.const(.spacing)),
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .const(.spacing)),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.const(.spacing))
        ])
        
        self.separatorInset = UIEdgeInsets(top: 0, left: .const(.spacing), bottom: 0, right: 0)
    }
    
    func configure(left: String, right: String) {
        leftLabel.text = left
        rightLabel.text = right
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
