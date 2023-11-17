//
//  LoginViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import OSLog
import AuthenticationServices
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel = LoginViewModel()
    
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
            guard let self = self else { return }
            self.viewModel.openAuthorizationController(delegate: self)
        }))
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = viewModel.getNonce() else {
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
            
            viewModel.login(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        os_log("애플 로그인에 실패했습니다. %@", log: OSLog.ui, type: .fault, error.localizedDescription)
    }
}
