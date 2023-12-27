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
    func googleLogin(delegate: UIViewController) async -> Result<UserResponse, Error>
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<UserResponse, Error>
}

final class LoginUseCase: LoginUseCaseProtocol {
    private var authService: FirebaseAuthServiceProtocol
    private var firestorageService: FirestorageServiceProtocol
    private var userService: UserServiceProtocol
    
    init(authService: FirebaseAuthServiceProtocol, userService: UserServiceProtocol, firestorageService: FirestorageServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.firestorageService = firestorageService
    }
    
    func googleLogin(delegate: UIViewController) async -> Result<UserResponse, Error> {
        let result = await authService.getFirebaseCredentialFromGoogle(presentView: delegate)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return await handleLoginResult(result)
        case .failure(let error):
            return .failure(NSError(domain: "LoginError: \(error)", code: -1, userInfo: nil))
        }
    }
    
    func appleLogin(credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<UserResponse, Error> {
        let result = await authService.getFirebaseCredentialFromApple(with: credential, nonce: nonce)
        switch result {
        case .success(let credential):
            let result = await authService.signIn(with: credential)
            return await handleLoginResult(result)
        case .failure(let error):
            return .failure(NSError(domain: "LoginError: \(error)", code: -1, userInfo: nil))
        }
    }
    
    private func handleLoginResult(_ result: Result<AuthDataResult, Error>) async -> Result<UserResponse, Error> {
        switch result {
        case .success(let authResult):
            do {
                let user = authResult.user
                if let userResult = try await userService.getUser(id: user.uid) {
                    let profileImage = await firestorageService.downloadImage(urlString: userResult.profileImage)
                    guard let profileImage else { return .failure(NSError(domain: "LoginError", code: -1, userInfo: nil)) }
                    return .success(UserResponse(user: userResult, image: profileImage, firstTime: false))
                }
                return .success(UserResponse(id: user.uid, nickName: user.displayName ?? "", email: user.email ?? "", firstTime: true))
            }
            catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
