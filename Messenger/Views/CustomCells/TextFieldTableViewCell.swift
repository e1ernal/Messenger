//
//  TextFieldTableView.swift
//  Messenger
//
//  Created by e1ernal on 12.02.2024.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    static let identifier = "TextFieldTableView"
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .font(.subtitle)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textAlignment = .left
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .clear
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constant(.spacing)),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constant(.spacing)),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constant(.spacing)),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constant(.spacing))
        ])
    }
    
    func configure(placeholder: String, text: String, tag: Int, delegate: UITextFieldDelegate) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder)
        textField.text = text
        textField.tag = tag
        textField.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}