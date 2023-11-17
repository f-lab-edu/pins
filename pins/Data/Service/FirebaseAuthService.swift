//
//  FirebaseAuthService.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import OSLog
import FirebaseAuth
import AuthenticationServices

protocol FirebaseAuthServiceProtocol {
    func signInWithApple(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func openAuthorizationController(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding)
    func getNonce() -> String?
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    private var currentNonce: String?
    
    func signInWithApple(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error  {
                os_log("Error Apple sign in: %@", log: .ui, type: .error, error.localizedDescription)
                completion(.failure(error))
            }
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func getNonce() -> String? {
        return currentNonce
    }
    
    func openAuthorizationController(delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
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
