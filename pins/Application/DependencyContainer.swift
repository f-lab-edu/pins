//
//  DependencyContainer.swift
//  pins
//
//  Created by 주동석 on 11/18/23.
//

import Foundation

enum DependencyContainer {
    static func registerDependencies() {
        loginDependencies()
    }
    
    static func loginDependencies() {
        // MARK: - Service
        DIContainer.shared.register(FirebaseAuthService() as FirebaseAuthServiceProtocol)
        // MARK: - UseCase
        DIContainer.shared.register(LoginUseCase() as LoginUseCaseProtocol)
        // MARK: - ViewModel
        DIContainer.shared.register(LoginViewModel())
    }
}
