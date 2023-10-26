//
//  CustomButton.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

class CustomButton: UIButton {
    init(backgroundColor: UIColor = .white, tintColor: UIColor = .gray) {
        super.init(frame: .zero)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    func setSize(width: CGFloat = 40.0, height: CGFloat = 40.0) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setShadow() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
    }
    
    func setImage(systemName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
    }
    
    func setTitle(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
    }
}
