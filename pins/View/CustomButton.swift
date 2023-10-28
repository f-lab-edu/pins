//
//  CustomButton.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

class CustomButton: UIButton {
    init(backgroundColor: UIColor = .white, tintColor: UIColor = .gray, cornerRadius: CGFloat = 15) {
        super.init(frame: .zero)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
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
    
    func setImageTitle(title: String, systemName: String, titleColor: UIColor, imageColor: UIColor) {
        var configuration = UIButton.Configuration.plain()
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 11)
            return outgoing
        }
        configuration.title = title
        configuration.titlePadding = 5
        configuration.image = UIImage.init(systemName: systemName)
        configuration.imagePadding = 5
        configuration.imagePlacement = .top
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        self.configuration = configuration
    }
    
    func setBorder(width: CGFloat, color: CGColor) {
        layer.borderColor = color
        layer.borderWidth = width
    }
}
