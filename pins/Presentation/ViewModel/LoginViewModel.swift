//
//  LoginViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/13.
//

import OSLog
import FirebaseAuth
import AuthenticationServices
import PinsUtilKit

final class LoginViewModel {
    @Published var loginState: Result<UserResponse, Error>?
    private var currentNonce: String?
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func performGoogleLogin(delegate: UIViewController) {
        Task {
            let result = await loginUseCase.googleLogin(delegate: delegate)
            loginState = result
        }
    }
    
    func performAppleLogin(credential: ASAuthorizationAppleIDCredential) {
        Task {
            let result = await loginUseCase.appleLogin(credential: credential, nonce: currentNonce)
            loginState = result
        }
    }
    
    func openAppleAuthorizationController(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        let nonce = CryptoUtils.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtils.sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = delegate
        authorizationController.performRequests()
    }
    
    func saveUserData(user: UserResponse) {
        KeychainManager.save(key: .userId, string: user.id)
        KeychainManager.save(key: .userEmail, string: user.email ?? "")
        guard let profileImage = user.profileImage else { return }
        KeychainManager.saveImage(image: profileImage, forKey: .userProfile)
    }
}
