//
//  SigninViewModel.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import Foundation

enum InputStep: Int {
    case nickName
    case birthDate
    case description
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
    
    func saveUserInfo() {
        print("save user info")
        print("nickName: \(nickName)")
        print("birthDate: \(birthDate)")
        print("description: \(description)")
    }
}
