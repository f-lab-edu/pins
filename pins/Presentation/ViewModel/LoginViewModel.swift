//
//  LoginViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/13.
//

import OSLog
import FirebaseAuth
import AuthenticationServices

final class LoginViewModel {
    @Dependency var loginUseCase: LoginUseCaseProtocol
    @Published var loginState: Result<User, Error>?
    private var currentNonce: String?
    
    func performGoogleLogin(delegate: UIViewController) {
        loginUseCase.googleLogin(delegate: delegate) { [weak self] result in
            self?.loginState = result
        }
    }
    
    func performAppleLogin(credential: ASAuthorizationAppleIDCredential) {
        loginUseCase.appleLogin(credential: credential, nonce: currentNonce) { [weak self] result in
            self?.loginState = result
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
}
