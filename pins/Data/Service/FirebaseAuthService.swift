//
//  FirebaseAuthService.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import OSLog
import FirebaseAuth
import AuthenticationServices
import FirebaseCore
import GoogleSignIn

protocol FirebaseAuthServiceProtocol {
    func signIn(with credential: AuthCredential) async -> Result<AuthDataResult, Error>
    func getFirebaseCredentialFromApple(with credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<AuthCredential, Error>
    func getFirebaseCredentialFromGoogle(presentView: UIViewController) async -> Result<AuthCredential, Error>
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    private var currentNonce: String?
    
    func signIn(with credential: AuthCredential) async -> Result<AuthDataResult, Error> {
        await withCheckedContinuation { continuation in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                } else if let authResult = authResult {
                    continuation.resume(returning: .success(authResult))
                }
            }
        }
    }
    
    func getFirebaseCredentialFromApple(with credential: ASAuthorizationAppleIDCredential, nonce: String?) async -> Result<AuthCredential, Error> {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = credential.identityToken else {
            os_log("Unable to fetch identity token", log: .ui, type: .error)
            return .failure(NSError(domain: "TokenError", code: -1, userInfo: nil))
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            os_log("Unable to serialize token string from data: %@", log: .ui, type: .error, appleIDToken.debugDescription)
            return .failure(NSError(domain: "TokenError", code: -1, userInfo: nil))
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        return .success(credential)
    }
    
    @MainActor
    func getFirebaseCredentialFromGoogle(presentView: UIViewController) async -> Result<AuthCredential, Error> {
        await withCheckedContinuation { continuation in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                os_log("Error Google sign in: %@", log: .ui, type: .error, "FirebaseApp.app()?.options.clientID is nil")
                return continuation.resume(returning: .failure(NSError(domain: "SignInError", code: -1, userInfo: nil)))
            }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            GIDSignIn.sharedInstance.signIn(withPresenting: presentView) { result, error in
                guard error == nil else {
                    os_log("Error Google sign in: %@", log: .ui, type: .error, error!.localizedDescription)
                    return continuation.resume(returning: .failure(error!))
                }
                guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                    os_log("Error Google sign in: %@", log: .ui, type: .error, "User or idToken is nil")
                    return continuation.resume(returning: .failure(NSError(domain: "SignInError", code: -1, userInfo: nil)))
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                continuation.resume(returning: .success(credential))
            }
        }
    }
}
