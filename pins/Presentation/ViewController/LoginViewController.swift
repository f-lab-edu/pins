//
//  LoginViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import UIKit
import OSLog
import Combine
import FirebaseAuth
import AuthenticationServices

final class LoginViewController: UIViewController {
    private lazy var authService: FirebaseAuthServiceProtocol = FirebaseAuthService()
    private lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCase(authService: authService)
    private lazy var viewModel: LoginViewModel = LoginViewModel(loginUseCase: loginUseCase)
    private var cancellables = Set<AnyCancellable>()

    var loginView: LoginView {
        view as! LoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
        setBindings()
    }
    
    override func loadView() {
        view = LoginView()
    }
        
    private func setBindings() {
        viewModel.$loginState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let user):
                    if user.firstTime {
                        self?.navigationController?.pushViewController(SigninViewController(), animated: true)
                    } else {
                        self?.navigationController?.pushViewController(MainViewController(), animated: true)
                    }
                case .failure(let error):
                    os_log("Login Error: %@", log: .default, type: .error, error.localizedDescription)
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setAction() {
        loginView.setAppleLoginAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.openAppleAuthorizationController(delegate: self)
        }))
        
        loginView.setGoogleLoginAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.performGoogleLogin(delegate: self)
        }))
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            viewModel.performAppleLogin(credential: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        os_log("애플 로그인에 실패했습니다. %@", log: OSLog.ui, type: .fault, error.localizedDescription)
    }
}
