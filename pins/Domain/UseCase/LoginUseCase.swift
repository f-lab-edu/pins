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
    private var userService: UserServiceProtocol
    
    init(authService: FirebaseAuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
    }
    
    func googleLogin(delegate: UIViewController) async -> Result<User, Error> {
        let result = await authService.getFirebaseCredentialFromGoogle(presentView: delegate)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return await handleLoginResult(result)
        case .failure(_):
            return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil))
        }
    }
    
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<User, Error> {
        let result = await authService.getFirebaseCredentialFromApple(with: credential, nonce: nonce)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return await handleLoginResult(result)
        case .failure(_):
            return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil))
        }
    }
    
    private func handleLoginResult(_ result: Result<AuthDataResult, Error>) async -> Result<User, Error> {
        switch result {
        case .success(let authResult):
            let creationDate = authResult.user.metadata.creationDate
            let lastSignInDate = authResult.user.metadata.lastSignInDate
            let user = authResult.user
            let userResult = await userService.getUser(id: user.uid)
            if let userResult = userResult {
                return .success(userResult)
            }
            guard let creationDate = creationDate, let lastSignInDate = lastSignInDate else {
                return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil))
            }
            if Calendar.current.isDate(creationDate, inSameDayAs: lastSignInDate) {
                return .success(User(id: user.uid, nickName: user.displayName ?? "", email: user.email, firstTime: true))
            } else {
                return .success(User(id: user.uid, nickName: user.displayName ?? "", email: user.email, firstTime: false))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
