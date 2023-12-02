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

final class SigninViewModel {
    @Published var inputStep: InputStep = .nickName
    
    func setInputStep(_ step: InputStep) {
        inputStep = step
    }
    
    func getInputStep() -> InputStep {
        inputStep
    }
}
