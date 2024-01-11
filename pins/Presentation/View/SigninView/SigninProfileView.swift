//
//  SigninProfileView.swift
//  pins
//
//  Created by 주동석 on 1/6/24.
//

import UIKit

final class SigninProfileView: UIView {
    let profileImage: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.setImage(UIImage.init(systemName: "photo.badge.plus", withConfiguration: largeConfig), for: .normal)
        return button
    }()
    private let validateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "프로필 이미지를 선택해주세요."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [profileImage, validateLabel].forEach { addSubview($0) }
        
        profileImage
            .topLayout(equalTo: topAnchor)
            .centerXLayout(equalTo: centerXAnchor)
            .widthLayout(100)
            .heightLayout(100)
        
        validateLabel
            .topLayout(equalTo: profileImage.bottomAnchor, constant: 5)
            .centerXLayout(equalTo: centerXAnchor)
    }
    
    func setValidateText(_ text: String) {
        validateLabel.text = text
    }
}
