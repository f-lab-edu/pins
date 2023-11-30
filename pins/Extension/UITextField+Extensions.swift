//
//  UITextField+Extensions.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ offset: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: offset, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
