//
//  FloatingTextField.swift
//  Messenger
//
//  Created by e1ernal on 18.12.2023.
//

import UIKit

final class FloatingTextField: UITextField, UITextFieldDelegate {
    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = Const.Color.inactive.cgColor
        view.layer.borderWidth = 1.0
        view.isUserInteractionEnabled = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Const.Font.body
        label.textColor = Const.Color.active
        label.backgroundColor = Const.Color.primaryBackground
        label.textAlignment = .center
        label.layer.opacity = 0.0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField(placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder)
        font = Const.Font.subtitle
        autocorrectionType = .no
        textAlignment = .center
        keyboardType = .default
        heightAnchor.constraint(equalToConstant: Const.Constraint.height).isActive = true
        borderView.layer.cornerRadius = Const.Constraint.height / 5

        borderView.frame = bounds
        titleLabel.text = " " + placeholder + " "

        addSubview(borderView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.Constraint.width)
        ])
    }

    func changeVisibility(isActive: Bool) {
        if isActive {
            UIView.animate(withDuration: 0.25) {
                self.borderView.layer.borderColor = Const.Color.active.cgColor
                self.titleLabel.layer.opacity = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.borderView.layer.borderColor = Const.Color.inactive.cgColor
                self.titleLabel.layer.opacity = 0.0
            }
        }
    }
}
