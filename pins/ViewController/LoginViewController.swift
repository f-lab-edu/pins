//
//  LoginViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import OSLog
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class LoginViewController: UIViewController {
    private var currentNonce: String?

    var loginView: LoginView {
        view as! LoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    private func setAction() {
        loginView.setLoginAction(UIAction(handler: { [weak self] _ in
            self?.startSignInWithAppleFlow()
        }))
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                os_log("Unable to fetch identity token", log: .ui, type: .error)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                os_log("Unable to serialize token string from data: %@", log: .ui, type: .error, appleIDToken.debugDescription)
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    os_log ("Error Apple sign in: %@", log: .ui, type: .error, error.localizedDescription)
                    return
                }
                
                let mainView: MainViewController = MainViewController()
                self?.navigationController?.pushViewController(mainView, animated: true)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        os_log("애플 로그인에 실패했습니다. %@", log: OSLog.ui, type: .fault, error.localizedDescription)
    }
}
