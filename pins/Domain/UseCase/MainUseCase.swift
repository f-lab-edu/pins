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
    func loadPin(pin: PinRequest) async throws -> PinResponse
    func fetchUserInfo() async throws -> UserRequest
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
    
    func loadPin(pin: PinRequest) async throws -> PinResponse {
        var imageDatas: [Data] = []
        for url in pin.urls {
            let image = await firestorageService.downloadImage(urlString: url)
            if let imageData = image?.pngData() {
                imageDatas.append(imageData)
            }
        }
        let user = try await userService.getUser(id: pin.userId)
        guard let user = user else { throw UserError.userFetchError }
        let profile = await firestorageService.downloadImage(urlString: user.profileImage)?.pngData()
        guard let profile else { throw UserError.userProfileImageNotFound }
        let userAge = user.birthDate?.birthDateToAge() ?? 0
        return PinResponse(pin: pin, images: imageDatas, id: user.id, name: user.nickName, age: userAge, description: user.description ?? "", profile: profile)
    }
    
    func fetchUserInfo() async throws -> UserRequest {
        guard let id = KeychainManager.load(key: .userId) else {
            throw UserError.userIdNotFound
        }
        guard let user = try await userService.getUser(id: id) else {
            throw UserError.userFetchError
        }
        return user
    }
}
