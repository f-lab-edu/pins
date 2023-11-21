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
    func signInWithApple(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func signInWithGoogle(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func getFirebaseCredentialFromApple(with credential: ASAuthorizationAppleIDCredential, nonce: String?, completion: @escaping (AuthCredential) -> Void)
    func getFirebaseCredentialFromGoogle(presentView: UIViewController, completion: @escaping (AuthCredential) -> Void)
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    private var currentNonce: String?
    
    func signInWithApple(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
           if let error = error {
               completion(.failure(error))
           } else if let authResult = authResult {
               completion(.success(authResult))
           }
       }
    }
    
    func signInWithGoogle(credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func getFirebaseCredentialFromApple(with credential: ASAuthorizationAppleIDCredential, nonce: String?, completion: @escaping (AuthCredential) -> Void) {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = credential.identityToken else {
            os_log("Unable to fetch identity token", log: .ui, type: .error)
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            os_log("Unable to serialize token string from data: %@", log: .ui, type: .error, appleIDToken.debugDescription)
            return
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: credential.fullName)
        completion(credential)
    }
    
    func getFirebaseCredentialFromGoogle(presentView: UIViewController, completion: @escaping (AuthCredential) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentView) { result, error in
            guard error == nil else {
                os_log("Error Google sign in: %@", log: .ui, type: .error, error!.localizedDescription)
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                os_log("Error Google sign in: %@", log: .ui, type: .error, "User or idToken is nil")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            completion(credential)
        }
    }
}
