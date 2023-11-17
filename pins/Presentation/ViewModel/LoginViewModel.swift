//
//  LoginViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/13.
//

import FirebaseAuth
import AuthenticationServices

final class LoginViewModel {
    private let loginUseCaseProtocol: LoginUseCaseProtocol = LoginUseCase()
    
    func openAuthorizationController(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        loginUseCaseProtocol.authorization(delegate: delegate)
    }
    
    func login(credential: AuthCredential) {
        loginUseCaseProtocol.login(credential: credential) { result in
            switch result {
            case .success(let user):
                print("Success login with \(user)")
            case .failure(let error):
                print("Error login with \(error)")
            }
        }
    }
    
    func getNonce() -> String? {
        loginUseCaseProtocol.getNonce()
    }
}
