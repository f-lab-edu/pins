//
//  MainViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import Foundation

final class MainViewModel {
    @Published var currentPins: [PinRequest] = []
    @Published var createViewIsPresented: Bool = false
    private var mainUseCase: MainUseCaseProtocol
    
    init(mainUseCase: MainUseCaseProtocol) {
        self.mainUseCase = mainUseCase
    }
    
    func setCurrentPins() async {
        let pins = await mainUseCase.getPins()
        currentPins = pins
    }
    
    func loadPin(pin: PinRequest) async throws -> PinResponse {
        do {
            return try await mainUseCase.loadPin(pin: pin)
        } catch {
            throw error
        }
    }
    
    func setCreateViewIsPresented(isPresented: Bool) {
        createViewIsPresented = isPresented
    }
    
    func getCreateViewIsPresented() -> Bool {
        return createViewIsPresented
    }
    
    func toggleCreateViewIsPresented() {
        createViewIsPresented.toggle()
    }
    
    func getUserInfo() async throws -> UserRequest {
        do {
            return try await mainUseCase.fetchUserInfo()
        } catch {
            throw error
        }
    }
}
