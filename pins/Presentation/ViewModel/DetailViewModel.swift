//
//  DetailViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/27.
//

import Foundation

final class DetailViewModel {
    @Published var currentPin: PinResponse?
    @Published var isImage: Bool = false
    
    func setIsImage(value: Bool) {
        isImage = value
    }
}
