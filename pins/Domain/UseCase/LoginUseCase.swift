//
//  LoginUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import OSLog
import FirebaseAuth
import AuthenticationServices

protocol LoginUseCaseProtocol {
    func googleLogin(delegate: UIViewController) async -> Result<User, Error>
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<User, Error>
}

final class LoginUseCase: LoginUseCaseProtocol {
    private var authService: FirebaseAuthServiceProtocol
    
    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }
    
    func googleLogin(delegate: UIViewController) async -> Result<User, Error> {
        let result = await authService.getFirebaseCredentialFromGoogle(presentView: delegate)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return handleLoginResult(result)
        case .failure(_):
            return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil))
        }
    }
    
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<User, Error> {
        let result = await authService.getFirebaseCredentialFromApple(with: credential, nonce: nonce)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return handleLoginResult(result)
        case .failure(_):
            return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil))
        }
    }
    
    private func handleLoginResult(_ result: Result<AuthDataResult, Error>) -> Result<User, Error> {
        switch result {
        case .success(let authResult):
            let user = authResult.user
            return .success(User(id: user.uid, name: user.displayName, email: user.email))
        case .failure(let error):
            return .failure(error)
        }
    }
}
