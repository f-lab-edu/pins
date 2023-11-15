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
    private let loginButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
    
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
        [icon, title, loginButton].forEach { addSubview($0) }
        
        icon.centerXLayout(equalTo: centerXAnchor)
            .centerYLayout(equalTo: centerYAnchor)
            .widthLayout(100)
            .heightLayout(100)
        
        title.centerXLayout(equalTo: centerXAnchor)
            .topLayout(equalTo: icon.bottomAnchor, constant: 20)
            .widthLayout(100)
            .heightLayout(50)
        
        loginButton.bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .heightLayout(45)
    }
    
    // MARK: - Methods
    func setLoginAction(_ action: UIAction) {
        loginButton.addAction(action, for: .touchUpInside)
    }
}
