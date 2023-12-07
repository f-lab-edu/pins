//
//  SigninUseCase.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import UIKit
import FirebaseAuth

protocol SigninUseCaseProtocol {
    func saveUserInfo(nickName: String, description: String, birthDate: String, image: ImageInfo) async
}

final class SigninUseCase: SigninUseCaseProtocol {
    private let userService: UserServiceProtocol
    private let firestorageService: FirestorageServiceProtocol
    
    init(userService: UserServiceProtocol, firestorageService: FirestorageServiceProtocol) {
        self.userService = userService
        self.firestorageService = firestorageService
    }
    
    func saveUserInfo(nickName: String, description: String, birthDate: String, image: ImageInfo) async {
        let imageUrl = await firestorageService.uploadImage(imageInfo: image)
        let userId = KeychainManager.load(key: "userId")
        let userEmail = KeychainManager.load(key: "userEmail")
        
        guard let userId, let userEmail else { return }
        
         let user = UserRequest(id: userId, nickName: nickName, email: userEmail, birthDate: birthDate, description: description, firstTime: false, profileImage: imageUrl.url.absoluteString)
         userService.putUser(user: user)
    }
}
