//
//  MainUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/23.
//

import UIKit

protocol MainUseCaseProtocol {
    func getPins() async -> [PinRequest]
    func loadPin(pin: PinRequest) async -> PinResponse
}

final class MainUseCase: MainUseCaseProtocol {
    private var firestorageService: FirestorageServiceProtocol
    
    init(firestorageService: FirestorageServiceProtocol) {
        self.firestorageService = firestorageService
    }
    
    func getPins() async -> [PinRequest] {
        return await firestorageService.getPins()
    }
    
    func loadPin(pin: PinRequest) async -> PinResponse {
        var images: [UIImage] = []
        // image download
        for url in pin.urls {
            let image = await firestorageService.downloadImage(urlString: url)
            if let image = image {
                images.append(image)
            }
        }
        return PinResponse(pin: pin, images: images)
    }
}
