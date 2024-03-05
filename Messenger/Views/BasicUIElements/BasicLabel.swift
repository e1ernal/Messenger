//
//  BasicLabel.swift
//  Messenger
//
//  Created by e1ernal on 07.01.2024.
//

import UIKit

class BasicLabel: UILabel {
    required init() {
        super.init(frame: .zero)
        initSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSetup() {
        textAlignment = .center
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(_ labelText: String, _ labelFont: UIFont) {
        self.init()
        text = labelText
        font = labelFont
    }
    
    convenience init(_ labelText: NSAttributedString) {
        self.init()
        attributedText = labelText
    }
}
