//
//  CGFloat.swift
//  Messenger
//
//  Created by e1ernal on 01.05.2024.
//

import Foundation

extension CGFloat {
    static func const(_ constant: Constraint) -> CGFloat {
        switch constant {
        case .doubleHeight:
            return 80.0
        case .imageHeight:
            return 60.0
        case .chatImageHeight:
            return 56.0
        case .digitsHeight:
            return 54.0 /* height * 1.34 */
        case .height:
            return 40.0
        case .doubleSpacing:
            return 20.0
        case .spacing:
            return 10.0
        case .halfSpacing:
            return 5.0
        case .cornerRadius:
            return 8.0 /* height * 0.25 */
        case .imageCornerRadius:
            return 30.0 /* imageHeight * 0.5 */
        case .chatImageCornerRadius:
            return 28.0 /* chatImageHeight * 0.5 */
        }
    }
}
