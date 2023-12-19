//
//  SceneDelegate.swift
//  pins
//
//  Created by 주동석 on 2023/10/19.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        // logout
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("Sign out error")
//        }
//        
        window.rootViewController = initialViewController()
//        window.rootViewController = SigninViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }

    private func initialViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        let isAuthenticated = checkAuthorizationState()
        let viewController: UIViewController
        if isAuthenticated {
            viewController = MainViewController()
        } else {
            viewController = LoginViewController()
        }
        navigationController.viewControllers = [viewController]
        
        return navigationController
    }

    private func checkAuthorizationState() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
