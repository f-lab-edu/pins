//
//  LoginView.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import AuthenticationServices

class LoginView: UIView {
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
    
    private func setLayout() {
        [icon, title, loginButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setLoginAction(_ action: UIAction) {
        loginButton.addAction(action, for: .touchUpInside)
    }
}
