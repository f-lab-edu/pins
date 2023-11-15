//
//  UIView.swift
//  pins
//
//  Created by 주동석 on 2023/11/06.
//

import UIKit

extension UIView {
    var activeConstraints: [NSLayoutConstraint] {
        return constraints + (superview?.constraints.filter { constraint in
            constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self
        } ?? [])
    }
    
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        let constraints = activeConstraints

        if let constraint = constraints.first(where: { $0.firstAttribute == attribute || $0.secondAttribute == attribute }) {
            constraint.constant = constant
        } else {
            fatalError("No constraint with attribute \(attribute) found")
        }
    }
    
    @discardableResult
    func centerXLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerYLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leadingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthLayout(_ constant: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightLayout(_ constant: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
}
