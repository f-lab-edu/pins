//
//  Pin.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import UIKit

struct PinRequest: Codable, Equatable {
    var id: String
    var title: String
    var content: String
    var longitude: Double
    var latitude: Double
    var category: String
    var created: String
    var userId: String
    var urls: [String] = []
    
    func withUrls(urls: [String]) -> PinRequest {
        var newPin = self
        newPin.urls = urls
        return newPin
    }
}
