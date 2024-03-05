//
//  BasicStackView.swift
//  Messenger
//
//  Created by e1ernal on 07.01.2024.
//

import UIKit

class BasicStackView: UIStackView {
    required init() {
        super.init(frame: .zero)
        initSetup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func initSetup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(_ stackAxis: NSLayoutConstraint.Axis, _ stackSpacing: CGFloat, _ stackDistribution: UIStackView.Distribution?, _ stackAlignment: UIStackView.Alignment?) {
        self.init()
        axis = stackAxis
        spacing = stackSpacing
        
        if let stackDistribution, let stackAlignment {
            distribution = stackDistribution
            alignment = stackAlignment
        }
    }
}
