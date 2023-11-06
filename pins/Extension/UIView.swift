//
//  UIView.swift
//  pins
//
//  Created by 주동석 on 2023/11/06.
//

import UIKit

extension UIView {
    func initLayout(_ parent: UIView) -> UIView {
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func centerXLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.centerXAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerYLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.centerYAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leadingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.leadingAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingLayout(equalTo: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.trailingAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.topAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomLayout(equalTo: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> UIView {
        self.bottomAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthLayout(_ constant: CGFloat) -> UIView {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightLayout(_ constant: CGFloat) -> UIView {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
}
