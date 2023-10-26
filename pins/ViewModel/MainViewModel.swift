//
//  MainViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import Foundation

class MainViewModel {
    @Published var createViewIsPresented: Bool = false
    
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
