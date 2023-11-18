//
//  LoginUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import FirebaseAuth
import AuthenticationServices

enum LoginMethod {
    case apple
}

protocol LoginUseCaseProtocol {
    func login(method: LoginMethod, credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void)
    func authorization(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding)
    func getNonce() -> String?
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let authService: FirebaseAuthServiceProtocol

    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }
    
    func authorization(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        authService.openAuthorizationController(delegate: delegate)
    }
    
    func login(method: LoginMethod, credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        switch method {
        case .apple:
            authService.signInWithApple(credential: credential, completion: completion)
        }
    }
    
    func getNonce() -> String? {
        return authService.getNonce()
    }
}
