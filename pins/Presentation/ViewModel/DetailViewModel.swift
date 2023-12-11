//
//  DetailViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/27.
//

import UIKit

final class DetailViewModel {
    @Published var currentPin: PinResponse?
    @Published var isImage: Bool = false
    @Published var page: Int = 1
    
    func setIsImage(value: Bool) {
        isImage = value
    }
    
    func setPage(value: Int) {
        page = value
    }
    
    func getImages() -> [UIImage] {
        guard let currentPin = currentPin else { return [] }
        return currentPin.images
    }
}
