//
//  CustomButton.swift
//  Messenger
//
//  Created by e1ernal on 06.01.2024.
//

import Foundation
import UIKit

class BasicButton: UIButton {
    private var action: () -> Void = {}
    
    private var type = Button.clear(.inactive)
    
    required init() {
        super.init(frame: .zero)
        initSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSetup() {
        heightAnchor.constraint(equalToConstant: .constant(.height)).isActive = true
        layer.cornerRadius = .constant(.cornerRadius)
        setupColors(type)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(title: String, style: Button, closure: @escaping () -> Void) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = .font(.button)
        
        type = style
        setupColors(type)
        
        action = closure
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(title: String) {
        setTitle(title, for: .normal)
    }
    
    @objc func buttonTapped() {
        action()
    }
    
    // Change button state: active / inactive
    func setState(_ state: ViewState) {
        switch type {
        case .filled:
            setupColors(.filled(state))
        case .clear:
            setupColors(.clear(state))
        }
    }
    
    private func setupColors(_ type: Button) {
        var buttonBackgroundColor: UIColor
        var buttonTitleColor: UIColor
        
        switch type {
        case .filled(let state):
            buttonTitleColor = .white
            switch state {
            case .active:
                buttonBackgroundColor = .color(.active)
            case .inactive:
                buttonBackgroundColor = .color(.inactive)
            }
        case .clear(let state):
            buttonBackgroundColor = .clear
            switch state {
            case .active:
                buttonTitleColor = .color(.active)
            case .inactive:
                buttonTitleColor = .color(.inactive)
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.setTitleColor(buttonTitleColor, for: .normal)
            self.backgroundColor = buttonBackgroundColor
        }
    }
}
