//
//  LoginView.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import AuthenticationServices

final class LoginView: UIView {
    // MARK: - Properties
    private let icon: UIImageView = UIImageView(image: UIImage(resource: .pinsIcon))
    private let title: UIImageView = UIImageView(image: UIImage(resource: .pinsTitle))
    private let appleLoginButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(resource: .appleLogin), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let googleLoginButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(resource: .googleLogin), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - Layouts
    private func setLayout() {
        [icon, title, appleLoginButton, googleLoginButton].forEach { addSubview($0) }
        
        icon.centerXLayout(equalTo: centerXAnchor)
            .centerYLayout(equalTo: centerYAnchor)
            .widthLayout(100)
            .heightLayout(100)
        
        title.centerXLayout(equalTo: centerXAnchor)
            .topLayout(equalTo: icon.bottomAnchor, constant: 20)
            .widthLayout(100)
            .heightLayout(50)
        
        appleLoginButton.bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
            .centerXLayout(equalTo: centerXAnchor)
            .heightLayout(50)
        
        googleLoginButton.bottomLayout(equalTo: appleLoginButton.topAnchor, constant: -10)
            .centerXLayout(equalTo: centerXAnchor)
            .heightLayout(50)
    }
    
    // MARK: - Methods
    func setAppleLoginAction(_ action: UIAction) {
        appleLoginButton.addAction(action, for: .touchUpInside)
    }
    
    func setGoogleLoginAction(_ action: UIAction) {
        googleLoginButton.addAction(action, for: .touchUpInside)
    }
}
