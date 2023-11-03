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
        window.rootViewController = initialViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }

    private func initialViewController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        checkAuthorizationState { isAuthenticated in
            let viewController: UIViewController
            if isAuthenticated {
                viewController = MainViewController()
            } else {
                viewController = LoginViewController()
            }
            navigationController.viewControllers = [viewController]
        }
        return navigationController
    }

    private func checkAuthorizationState(completion: @escaping (Bool) -> Void) {
        var isAuthenticated = false
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                isAuthenticated = true
            } else {
                isAuthenticated = false
            }
        }
        
        DispatchQueue.main.async {
            completion(isAuthenticated)
        }
    }
}

