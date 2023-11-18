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
    func googleLogin(delegate: UIViewController, completion: @escaping (Result<User, Error>) -> Void)
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?, completion: @escaping (Result<User, Error>) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    @Dependency var authService: FirebaseAuthServiceProtocol
    
    func googleLogin(delegate: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        authService.getFirebaseCredentialFromGoogle(presentView: delegate) { [weak self] credential in
            guard let self = self else { return }
            self.authService.signInWithGoogle(credential: credential) { result in
                self.handleLoginResult(result, completion: completion)
            }
        }
    }
    
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?, completion: @escaping (Result<User, Error>) -> Void) {
        authService.getFirebaseCredentialFromApple(with: credential, nonce: nonce) { [weak self] credential in
            guard let self = self else { return }
            self.authService.signInWithApple(credential: credential) { result in
                self.handleLoginResult(result, completion: completion)
            }
        }
    }
    
    private func handleLoginResult(_ result: Result<AuthDataResult, Error>, completion: @escaping (Result<User, Error>) -> Void) {
        switch result {
        case .success(let user):
            // 추가적인 성공 처리 로직이 필요한 경우 여기에 구현
            let user = User(id: user.user.uid, name: user.user.displayName, email: user.user.email)
            completion(.success(user))
        case .failure(let error):
            // 에러 핸들링 로직
            completion(.failure(error))
        }
    }
}
