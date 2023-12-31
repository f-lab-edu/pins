//
//  SigninViewModel.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import UIKit

enum InputStep: Int {
    case nickName
    case birthDate
    case description
    case profileImage
}

enum InputButtonStype {
    case enabled
    case disabled
}

final class SigninViewModel {
    @Published var inputStep: InputStep = .nickName
    @Published var inputButtonStyle: InputButtonStype = .disabled
    @Published var nickName: String = ""
    @Published var birthDate: String = ""
    @Published var description: String = ""
    @Published var profileImage: ImageInfo = ImageInfo(index: 0, image: .person, extensionType: "png")
    private let signinUsecase: SigninUseCaseProtocol
    
    init(signinUsecase: SigninUseCaseProtocol) {
        self.signinUsecase = signinUsecase
    }
    
    func setInputButtonStyle(_ style: InputButtonStype) {
        inputButtonStyle = style
    }
    
    func setInputStep(_ step: InputStep) {
        inputStep = step
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
