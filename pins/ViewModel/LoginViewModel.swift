//
//  LoginViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/13.
//

import AuthenticationServices

class LoginViewModel {
    private let appleLoginService: AppleLoginService = AppleLoginService()
    
    func getAppleNonce() -> String? {
        appleLoginService.getNonce()
    }
    
    func appleLogin(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        appleLoginService.login(delegate: delegate)
    }
}
