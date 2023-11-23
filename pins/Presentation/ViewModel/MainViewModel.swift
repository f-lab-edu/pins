//
//  MainViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import Foundation

final class MainViewModel {
    @Published var currentPins: [Pin] = []
    @Published var createViewIsPresented: Bool = false
    private var mainUseCase: MainUseCaseProtocol
    
    init(mainUseCase: MainUseCaseProtocol) {
        self.mainUseCase = mainUseCase
    }
    
    func getPins() async -> [Pin] {
        return await mainUseCase.getPins()
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
}
