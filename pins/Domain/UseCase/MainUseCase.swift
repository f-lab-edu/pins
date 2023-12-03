//
//  MainUseCase.swift
//  pins
//
//  Created by 주동석 on 2023/11/23.
//

import UIKit
import FirebaseAuth

protocol MainUseCaseProtocol {
    func getPins() async -> [PinRequest]
    func loadPin(pin: PinRequest) async -> PinResponse
    func fetchUserInfo() async -> User
}

final class MainUseCase: MainUseCaseProtocol {
    private var firestorageService: FirestorageServiceProtocol
    private var userService: UserServiceProtocol
    
    init(firestorageService: FirestorageServiceProtocol, userService: UserServiceProtocol) {
        self.firestorageService = firestorageService
        self.userService = userService
    }
    
    func getPins() async -> [PinRequest] {
        return await firestorageService.getPins()
    }
    
    func loadPin(pin: PinRequest) async -> PinResponse {
        var images: [UIImage] = []
        for url in pin.urls {
            let image = await firestorageService.downloadImage(urlString: url)
            if let image = image {
                images.append(image)
            }
        }
        return PinResponse(pin: pin, images: images)
    }
    
    func fetchUserInfo() async -> User {
        let id = Auth.auth().currentUser!.uid
        let user = await userService.getUser(id: id)
        guard let user = user else { fatalError("Error fetching user") }
        return user
    }
}
