//
//  LoginViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
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
        loginView.setLoginAction(UIAction(handler: { _ in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            print(ASAuthorizationAppleIDProvider().getCredentialState(forUserID: UserDefaults.standard.string(forKey: "UserId") ?? "") { (credential, error) in
                switch credential {
                case .authorized:
                    print("authorized")
                case .revoked:
                    print("revoked")
                case .notFound:
                    print("notFound")
                default:
                    break
                }
            })
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }))
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserDefaults.standard.setValue(credential.user, forKey: "UserId")
        credential.
        // 처음 애플 로그인 시 이메일은 credential.fullName 에 들어있다.
        if let fullName = credential.fullName {
            print("이름 : \(fullName.familyName ?? "")\(fullName.givenName ?? "")")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패 \(error)")
    }
}
