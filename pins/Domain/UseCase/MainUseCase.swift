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
    func fetchUserInfo() async -> UserRequest
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
        let user = await userService.getUser(id: pin.userId)
        guard let user = user else { fatalError("Error fetching user") }
        let profile = await firestorageService.downloadImage(urlString: user.profileImage)
        guard let profile else { fatalError("Error feching profile") }
        let userAge = user.birthDate?.birthDateToAge() ?? 0
        return PinResponse(pin: pin, images: images, id: user.id, name: user.nickName, age: userAge, description: user.description ?? "", profile: profile)
    }
    
    func fetchUserInfo() async -> UserRequest {
        let id = KeychainManager.load(key: "userId")
        guard let id else { fatalError("userId is nil")}
        let user = await userService.getUser(id: id)
        guard let user = user else { fatalError("Error fetching user") }
        return user
    }
}
