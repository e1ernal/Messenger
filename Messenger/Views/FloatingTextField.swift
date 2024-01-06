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
        view.layer.borderColor = .color(.inactive)
        view.layer.borderWidth = 1.0
        view.isUserInteractionEnabled = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.body)
        label.textColor = .color(.active)
        label.backgroundColor = .color(.background)
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
        font = .font(.textField)
        autocorrectionType = .no
        textAlignment = .center
        keyboardType = .default
        borderView.layer.cornerRadius = .constant(.cornerRadius)
        heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        borderView.frame = bounds
        titleLabel.text = " \(placeholder) "

        addSubview(borderView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .constant(.spacing))
        ])
    }

    func changeVisibility(isActive: Bool) {
        let color: CGColor = isActive ? .color(.active) : .color(.inactive)
        let opacity: Float = isActive ? 1.0 : 0.0
        
        UIView.animate(withDuration: 0.25) {
            self.borderView.layer.borderColor = color
            self.titleLabel.layer.opacity = opacity
        }
    }
}
