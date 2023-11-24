//
//  UILabel+Extensions.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight

        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text)
        }
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        attributedText = attributedString
    }
}
