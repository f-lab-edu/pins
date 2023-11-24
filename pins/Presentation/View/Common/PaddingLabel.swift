//
//  PaddingLabel.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit

final class PaddingLabel: UILabel {
    private var topInset: CGFloat = 0.0
    private var bottomInset: CGFloat = 0.0
    private var leftInset: CGFloat = 0.0
    private var rightInset: CGFloat = 0.0
    
    init(topInset: CGFloat, bottomInset: CGFloat, leftInset: CGFloat, rightInset: CGFloat) {
        super.init(frame: .zero)
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    func setCornerRadius(offset: CGFloat) {
        heightLayout(offset * 2)
        layer.cornerRadius = offset
        layer.masksToBounds = true
    }
}

