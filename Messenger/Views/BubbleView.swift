//
//  BubbleView.swift
//  Messenger
//
//  Created by e1ernal on 26.04.2024.
//

import Foundation
import UIKit

class BubbleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        super.backgroundColor = .clear
    }
    
    private var bubbleColor: UIColor? {
        didSet { setNeedsDisplay() }
    }
    
    override var backgroundColor: UIColor? {
        get { return bubbleColor }
        set { bubbleColor = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }
    
    var side: Side = .right {
        didSet { setNeedsDisplay() }
    }
    
    var roundType: RoundType = .startEnd {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = borderWidth
        
        let bottom = rect.height - borderWidth
        let right = rect.width - borderWidth
        let top = borderWidth
        let left = borderWidth
        
        switch side {
        case .left:
            switch roundType {
            case .start:
                bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17),
                                    controlPoint1: CGPoint(x: right - 7.61, y: bottom),
                                    controlPoint2: CGPoint(x: right, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: right - 17, y: top),
                                    controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: right - 7.61, y: top))
                bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
                bezierPath.addCurve(to: CGPoint(x: 4 + borderWidth, y: 17 + borderWidth),
                                    controlPoint1: CGPoint(x: 11.61 + borderWidth, y: top),
                                    controlPoint2: CGPoint(x: borderWidth + 4, y: 7.61 + borderWidth))
                bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 5))
                bezierPath.addArc(withCenter: CGPoint(x: borderWidth + 9, y: bottom - 5),
                                  radius: 5,
                                  startAngle: .pi,
                                  endAngle: .pi / 2,
                                  clockwise: false)
            case .between:
                bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17),
                                    controlPoint1: CGPoint(x: right - 7.61, y: bottom),
                                    controlPoint2: CGPoint(x: right, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: right - 17, y: top),
                                    controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: right - 7.61, y: top))
                bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
                bezierPath.addArc(withCenter: CGPoint(x: borderWidth + 9, y: top + 5),
                                  radius: 5,
                                  startAngle: 1.5 * .pi,
                                  endAngle: .pi,
                                  clockwise: false)
                bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 5))
                bezierPath.addArc(withCenter: CGPoint(x: borderWidth + 9, y: bottom - 5),
                                  radius: 5,
                                  startAngle: .pi,
                                  endAngle: .pi / 2,
                                  clockwise: false)
            case .end:
                bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17),
                                    controlPoint1: CGPoint(x: right - 7.61, y: bottom),
                                    controlPoint2: CGPoint(x: right, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: right - 17, y: top),
                                    controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: right - 7.61, y: top))
                bezierPath.addLine(to: CGPoint(x: 9 + borderWidth, y: top))
                bezierPath.addArc(withCenter: CGPoint(x: borderWidth + 9, y: top + 5),
                                  radius: 5,
                                  startAngle: 1.5 * .pi,
                                  endAngle: .pi,
                                  clockwise: false)
                bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 11))
                bezierPath.addCurve(to: CGPoint(x: borderWidth, y: bottom),
                                    controlPoint1: CGPoint(x: borderWidth + 4, y: bottom - 1),
                                    controlPoint2: CGPoint(x: borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: borderWidth - 0.05, y: bottom - 0.01))
                bezierPath.addCurve(to: CGPoint(x: borderWidth + 11.04, y: bottom - 4.04),
                                    controlPoint1: CGPoint(x: borderWidth + 4.07, y: bottom + 0.43),
                                    controlPoint2: CGPoint(x: borderWidth + 8.16, y: bottom - 1.06))
                bezierPath.addCurve(to: CGPoint(x: borderWidth + 22, y: bottom),
                                    controlPoint1: CGPoint(x: borderWidth + 16, y: bottom),
                                    controlPoint2: CGPoint(x: borderWidth + 19, y: bottom))
            case .startEnd:
                bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17),
                                    controlPoint1: CGPoint(x: right - 7.61, y: bottom),
                                    controlPoint2: CGPoint(x: right, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: right - 17, y: top),
                                    controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: right - 7.61, y: top))
                bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
                bezierPath.addCurve(to: CGPoint(x: 4 + borderWidth, y: 17 + borderWidth),
                                    controlPoint1: CGPoint(x: 11.61 + borderWidth, y: top),
                                    controlPoint2: CGPoint(x: borderWidth + 4, y: 7.61 + borderWidth))
                bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 11))
                bezierPath.addCurve(to: CGPoint(x: borderWidth, y: bottom),
                                    controlPoint1: CGPoint(x: borderWidth + 4, y: bottom - 1),
                                    controlPoint2: CGPoint(x: borderWidth, y: bottom))
                bezierPath.addLine(to: CGPoint(x: borderWidth - 0.05, y: bottom - 0.01))
                bezierPath.addCurve(to: CGPoint(x: borderWidth + 11.04, y: bottom - 4.04),
                                    controlPoint1: CGPoint(x: borderWidth + 4.07, y: bottom + 0.43),
                                    controlPoint2: CGPoint(x: borderWidth + 8.16, y: bottom - 1.06))
                bezierPath.addCurve(to: CGPoint(x: borderWidth + 22, y: bottom),
                                    controlPoint1: CGPoint(x: borderWidth + 16, y: bottom),
                                    controlPoint2: CGPoint(x: borderWidth + 19, y: bottom))
            }
        case .right:
            switch roundType {
            case .start:
                bezierPath.move(to: CGPoint(x: right - 22, y: bottom))
                bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18),
                                    controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom),
                                    controlPoint2: CGPoint(x: left, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top),
                                    controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
                bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
                bezierPath.addCurve(to: CGPoint(x: right - 4, y: 17 + borderWidth),
                                    controlPoint1: CGPoint(x: right - 11.61, y: top),
                                    controlPoint2: CGPoint(x: right - 4, y: 7.61 + borderWidth))
                bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 5))
                bezierPath.addArc(withCenter: CGPoint(x: right - 9, y: bottom - 5),
                                  radius: 5,
                                  startAngle: 0,
                                  endAngle: .pi / 2,
                                  clockwise: true)
            case .between:
                bezierPath.move(to: CGPoint(x: right - 22, y: bottom))
                bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18),
                                    controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom),
                                    controlPoint2: CGPoint(x: left, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top),
                                    controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
                bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
                bezierPath.addArc(withCenter: CGPoint(x: right - 9, y: 5),
                                  radius: 5,
                                  startAngle: 1.5 * .pi,
                                  endAngle: 0,
                                  clockwise: true)
                bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
                bezierPath.addArc(withCenter: CGPoint(x: right - 9, y: bottom - 5),
                                  radius: 5,
                                  startAngle: 0,
                                  endAngle: .pi / 2,
                                  clockwise: true)
            case .end:
                bezierPath.move(to: CGPoint(x: right - 22, y: bottom))
                bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18),
                                    controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom),
                                    controlPoint2: CGPoint(x: left, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top),
                                    controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
                bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
                bezierPath.addArc(withCenter: CGPoint(x: right - 9, y: 5),
                                  radius: 5,
                                  startAngle: 1.5 * .pi,
                                  endAngle: 0,
                                  clockwise: true)
                bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom),
                                    controlPoint1: CGPoint(x: right - 4, y: bottom - 1),
                                    controlPoint2: CGPoint(x: right, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right + 0.05, y: bottom - 0.01))
                bezierPath.addCurve(to: CGPoint(x: right - 11.04, y: bottom - 4.04),
                                    controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43),
                                    controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06))
                bezierPath.addCurve(to: CGPoint(x: right - 22, y: bottom),
                                    controlPoint1: CGPoint(x: right - 16, y: bottom),
                                    controlPoint2: CGPoint(x: right - 19, y: bottom))
            case .startEnd:
                bezierPath.move(to: CGPoint(x: right - 22, y: bottom))
                bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
                bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18),
                                    controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom),
                                    controlPoint2: CGPoint(x: left, y: bottom - 7.61))
                bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
                bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top),
                                    controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth),
                                    controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
                bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
                bezierPath.addCurve(to: CGPoint(x: right - 4, y: 17 + borderWidth),
                                    controlPoint1: CGPoint(x: right - 11.61, y: top),
                                    controlPoint2: CGPoint(x: right - 4, y: 7.61 + borderWidth))
                bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
                bezierPath.addCurve(to: CGPoint(x: right, y: bottom),
                                    controlPoint1: CGPoint(x: right - 4, y: bottom - 1),
                                    controlPoint2: CGPoint(x: right, y: bottom))
                bezierPath.addLine(to: CGPoint(x: right + 0.05, y: bottom - 0.01))
                bezierPath.addCurve(to: CGPoint(x: right - 11.04, y: bottom - 4.04),
                                    controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43),
                                    controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06))
                bezierPath.addCurve(to: CGPoint(x: right - 22, y: bottom),
                                    controlPoint1: CGPoint(x: right - 16, y: bottom),
                                    controlPoint2: CGPoint(x: right - 19, y: bottom))
            }
        }
        
        bezierPath.close()
        
        backgroundColor?.setFill()
        borderColor.setStroke()
        bezierPath.fill()
        bezierPath.stroke()
    }
}
