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
    
    func getPins() {
        Task {
            currentPins = await mainUseCase.getPins()
        }
    }
    
    func loadPin(pin: PinRequest) async -> PinResponse {
        return await mainUseCase.loadPin(pin: pin)
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
    
    func getUserInfo() async -> UserRequest {
        return await mainUseCase.fetchUserInfo()
    }
}
