//
//  Pin.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import UIKit

struct Pin: Codable {
    var id: String
    var title: String
    var content: String
    var longitude: Double
    var latitude: Double
    var category: String
    var created: String
    var urls: [String] = []
    
    func withUrls(urls: [String]) -> Pin {
        var newPin = self
        newPin.urls = urls
        return newPin
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "content": content,
            "longitude": longitude,
            "latitude": latitude,
            "category": category,
            "created": created,
            "urls": urls,
        ]
    }
}
