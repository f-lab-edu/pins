//
//  SigninUseCase.swift
//  pins
//
//  Created by 주동석 on 12/3/23.
//

import UIKit
import FirebaseAuth

protocol SigninUseCaseProtocol {
    func saveUserInfo(nickName: String, description: String, birthDate: String, imageInfo: ImageInfo) async throws
}

final class SigninUseCase: SigninUseCaseProtocol {
    private let userService: UserServiceProtocol
    private let firestorageService: FirestorageServiceProtocol
    
    init(userService: UserServiceProtocol, firestorageService: FirestorageServiceProtocol) {
        self.userService = userService
        self.firestorageService = firestorageService
    }
    
    func saveUserInfo(nickName: String, description: String, birthDate: String, imageInfo: ImageInfo) async throws {
        let imageUrl = await firestorageService.uploadImage(imageInfo: imageInfo)
        let userId = KeychainManager.load(key: .userId)
        let userEmail = KeychainManager.load(key: .userEmail)
        KeychainManager.saveImage(image: imageInfo.image, forKey: .userProfile)
        
        guard let userId, let userEmail else { return }
        
        let user = UserRequest(id: userId, nickName: nickName, email: userEmail, birthDate: birthDate, description: description, firstTime: false, profileImage: imageUrl.url.absoluteString)
        do {
            try await userService.putUser(user: user)
        } catch {
            throw error
        }
    }
}
