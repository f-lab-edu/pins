//
//  MainUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/23.
//

import Foundation

protocol MainUseCaseProtocol {
    func getPins() async -> [Pin]
}

final class MainUseCase: MainUseCaseProtocol {
    private var firestorageService: FirestorageServiceProtocol
    
    init(firestorageService: FirestorageServiceProtocol) {
        self.firestorageService = firestorageService
    }
    
    func getPins() async -> [Pin] {
        return await firestorageService.getPins()
    }
}
