//
//  UIView.swift
//  pins
//
//  Created by 주동석 on 2023/11/06.
//

import UIKit

extension UIView {
    private static var activeConstraintsKey: UInt8 = 0
    private var activeConstraints: [NSLayoutConstraint.Attribute: NSLayoutConstraint] {
        get {
            return objc_getAssociatedObject(self, &UIView.activeConstraintsKey) as? [NSLayoutConstraint.Attribute: NSLayoutConstraint] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &UIView.activeConstraintsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func activateConstraint(_ constraint: NSLayoutConstraint, for attribute: NSLayoutConstraint.Attribute) {
        // 먼저, 기존의 동일한 attribute의 constraint를 비활성화하고 제거합니다.
        if let existingConstraint = activeConstraints[attribute] {
            existingConstraint.isActive = false
            self.removeConstraint(existingConstraint)
        }

        // 새로운 constraint를 활성화하고 저장합니다.
        self.translatesAutoresizingMaskIntoConstraints = false
        activeConstraints[attribute] = constraint
        constraint.isActive = true
    }
    
    @discardableResult
    func centerXLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let centerX = self.centerXAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(centerX, for: .centerX)
        return self
    }
    
    @discardableResult
    func centerYLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let centerY = self.centerYAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(centerY, for: .centerY)
        return self
    }
    
    @discardableResult
    func leadingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let leading = self.leadingAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(leading, for: .leading)
        return self
    }
    
    @discardableResult
    func trailingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let trailing = self.trailingAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(trailing, for: .trailing)
        return self
    }
    
    @discardableResult
    func topLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let top = self.topAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(top, for: .top)
        return self
    }
    
    @discardableResult
    func bottomLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        let bottom = self.bottomAnchor.constraint(equalTo: equalTo, constant: constant)
        activateConstraint(bottom, for: .bottom)
        return self
    }
    
    @discardableResult
    func widthLayout(_ constant: CGFloat) -> UIView {
        let width = self.widthAnchor.constraint(equalToConstant: constant)
        activateConstraint(width, for: .width)
        return self
    }
    
    @discardableResult
    func heightLayout(_ constant: CGFloat) -> UIView {
        let height = self.heightAnchor.constraint(equalToConstant: constant)
        activateConstraint(height, for: .height)
        return self
    }
}

extension UIView {
    func showToast(message: String, duration: TimeInterval = 1.0) {
        let toastLabel = PaddingLabel(inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        toastLabel
            .bottomLayout(equalTo: self.bottomAnchor, constant: -100)
            .centerXLayout(equalTo: self.centerXAnchor)
            .heightLayout(30)
        UIView.animate(withDuration: duration, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
