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
import SwiftUI

final class LoginViewController: UIViewController {
    private lazy var authService: FirebaseAuthServiceProtocol = FirebaseAuthService()
    private lazy var userRepository: UserRepositoryProtocol = UserRepository()
    private lazy var firebaseRepository: FirebaseRepositoryProtocol = FirebaseRepository()
    private lazy var firestorageService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: firebaseRepository)
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCase(authService: authService, userService: userService, firestorageService: firestorageService)
    private lazy var viewModel: LoginViewModel = LoginViewModel(loginUseCase: loginUseCase)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setBindings()
    }
    
    private func setView() {
        let hostingController = UIHostingController(rootView: LoginView(appleLoginAction: {
            self.viewModel.openAppleAuthorizationController(delegate: self)
        }, googleLoginAction: {
            self.viewModel.performGoogleLogin(delegate: self)
        }))
        let loginView = hostingController.view!
        loginView.backgroundColor = .white
        view.addSubview(loginView)
        loginView
            .topLayout(equalTo: view.topAnchor)
            .leadingLayout(equalTo: view.leadingAnchor)
            .trailingLayout(equalTo: view.trailingAnchor)
            .bottomLayout(equalTo: view.bottomAnchor)
        hostingController.didMove(toParent: self)
    }
    
    private func setBindings() {
        viewModel.$loginState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let user):
                    self?.viewModel.saveUserData(user: user)
                    if user.firstTime {
                        self?.navigationController?.pushViewController(SigninViewController(), animated: true)
                    } else {
                        self?.navigationController?.pushViewController(MainViewController(), animated: true)
                    }
                case .failure(let error):
                    self?.view.showToast(message: "로그인 중 문제가 발생했습니다: \(error.localizedDescription)")
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
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
