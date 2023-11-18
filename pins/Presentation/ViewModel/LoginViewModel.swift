//
//  LoginViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/13.
//

import FirebaseAuth
import AuthenticationServices

final class LoginViewModel {
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func openAuthorizationController(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        loginUseCase.authorization(delegate: delegate)
    }
    
    func loginWithApple(credential: AuthCredential) {
        loginUseCase.login(method: .apple, credential: credential) { result in
            switch result {
            case .success(let user):
                print("Success login with \(user)")
            case .failure(let error):
                print("Error login with \(error)")
            }
        }
    }
    
    func getNonce() -> String? {
        loginUseCase.getNonce()
    }
}
