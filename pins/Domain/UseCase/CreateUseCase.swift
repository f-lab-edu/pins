//
//  CreateUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/22.
//

import UIKit

protocol CreateUseCaseProtocol {
    func createPin(pin: Pin, imageInfos: [ImageInfo]) async
}

final class CreateUseCase: CreateUseCaseProtocol {
    private var firestorageService: FirestorageServiceProtocol
    
    init(firestorageService: FirestorageServiceProtocol) {
        self.firestorageService = firestorageService
    }
    
    func createPin(pin: Pin, imageInfos: [ImageInfo]) async {
        await firestorageService.createPin(pin: pin, images: imageInfos)
    }
}
