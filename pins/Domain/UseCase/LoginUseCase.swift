//
//  LoginUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import FirebaseAuth
import AuthenticationServices

protocol LoginUseCaseProtocol {
    func login(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void)
    func authorization(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding)
    func getNonce() -> String?
}

class LoginUseCase: LoginUseCaseProtocol {
    private let authService: FirebaseAuthServiceProtocol = FirebaseAuthService()

    func authorization(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        authService.openAuthorizationController(delegate: delegate)
    }
    
    func login(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        authService.signInWithApple(credential: credential) { result in
            switch result {
            case .success(let authDataResult):
                let user = User(id: authDataResult.user.uid, name: authDataResult.user.displayName, email: authDataResult.user.email)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNonce() -> String? {
        return authService.getNonce()
    }
}
