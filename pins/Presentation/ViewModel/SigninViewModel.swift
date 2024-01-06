//
//  SigninViewModel.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import UIKit

enum InputButtonStype {
    case enabled
    case disabled
}

final class SigninViewModel {
    @Published var inputButtonStyle: InputButtonStype = .disabled
    @Published var nickName: String = ""
    @Published var birthDate: String = ""
    @Published var description: String = ""
    @Published var profileImage: ImageInfo?
    private let signinUsecase: SigninUseCaseProtocol
    
    init(signinUsecase: SigninUseCaseProtocol) {
        self.signinUsecase = signinUsecase
    }
    
    func setInputButtonStyle(_ style: InputButtonStype) {
        inputButtonStyle = style
    }
    func setNickName(_ nickName: String) {
        self.nickName = nickName
    }
    
    func setBirthDate(_ birthDate: String) {
        self.birthDate = birthDate
    }
    
    func setDescription(_ description: String) {
        self.description = description
    }
    
    func saveUserInfo() async throws {
        guard let profileImage = profileImage else { return }
        do {
            try await signinUsecase.saveUserInfo(nickName: nickName, description: description, birthDate: birthDate, imageInfo: profileImage)
        } catch {
            throw error
        }
    }
    
    func setProfileImage(_ image: UIImage, type: String) {
        profileImage = ImageInfo(index: 0, image: image, extensionType: type)
    }
}
