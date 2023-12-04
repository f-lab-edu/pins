//
//  SigninUseCase.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import Foundation
import FirebaseAuth

protocol SigninUseCaseProtocol {
    func saveUserInfo(nickName: String, description: String, birthDate: String)
}

final class SigninUseCase: SigninUseCaseProtocol {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func saveUserInfo(nickName: String, description: String, birthDate: String) {
        if let userData = KeychainManager.load(key: "currentUser"),
           let loadedUser = try? JSONDecoder().decode(User.self, from: userData) {
            let user = User(id: loadedUser.id, nickName: nickName, email: loadedUser.email, birthDate: birthDate, description: description, firstTime: false)
            userService.putUser(user: user)
        }
    }
}
