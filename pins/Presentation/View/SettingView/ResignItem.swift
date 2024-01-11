//
//  ResignItem.swift
//  pins
//
//  Created by 주동석 on 1/8/24.
//

import UIKit
import OSLog
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import PinsUtilKit

final class ResignItem: SettingItemHandling {
    private lazy var authService: FirebaseAuthServiceProtocol = FirebaseAuthService()
    private lazy var userRepository: UserRepositoryProtocol = UserRepository()
    private lazy var firebaseRepository: FirebaseRepositoryProtocol = FirebaseRepository()
    private lazy var firestorageService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: firebaseRepository)
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCase(authService: authService, userService: userService, firestorageService: firestorageService)
    private lazy var viewModel: LoginViewModel = LoginViewModel(loginUseCase: loginUseCase)
    private var loginViewController = LoginViewController()
    
    var title: String = "회원탈퇴"
    var navigationController: UINavigationController?
    var onPresentAlert: ((UIAlertController) -> Void)?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func performAction() {
        let alert = ConfirmManager.makeAlert(title: "회원 탈퇴", message: "정말 회원을 탈퇴하시겠습니까?") { [weak self] in
            self?.resignation()
        }
        onPresentAlert?(alert)
    }
    
    private func resignation() {
        let user = Auth.auth().currentUser
        
        user?.delete { [weak self] error in
            if error != nil {
                self?.reAuthenticate()
            } else {
                do {
                    try Auth.auth().signOut()
                    self?.navigationController?.viewControllers = [LoginViewController()]
                } catch {
                    os_log("resignation error")
                }
            }
        }
    }
    
    private func getNewCredential() async -> AuthCredential {
        guard let user = Auth.auth().currentUser else { fatalError("get current user error") }
        guard let navigationController = navigationController else { fatalError("get navigationController error") }
        let providerID = user.providerData[0].providerID
        var newCredential: AuthCredential!

        switch providerID {
        case GoogleAuthProviderID:
            let result = await authService.getFirebaseCredentialFromGoogle(presentView: navigationController.topViewController!)
            switch result {
            case .success(let credential):
                newCredential = credential
            case .failure:
                break
            }
        case "apple.com":
            viewModel.openAppleAuthorizationController(delegate: loginViewController)
        default:
            break
        }
        
        return newCredential
    }
    
    private func reAuthenticate() {
        Task {
            guard let user = Auth.auth().currentUser else { return }
            do {
                let newCredential = await getNewCredential()
                try await user.reauthenticate(with: newCredential)
                resignation()
            } catch {
                os_log("\(error.localizedDescription)")
            }
        }
    }
}
