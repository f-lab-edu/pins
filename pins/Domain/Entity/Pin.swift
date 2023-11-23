//
//  Pin.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import UIKit

struct Pin: Codable, Equatable {
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
    
    static func toData(_ data: [String: Any]) -> Pin {
        return Pin(
            id: data["id"] as! String,
            title: data["title"] as! String,
            content: data["content"] as! String,
            longitude: data["longitude"] as! Double,
            latitude: data["latitude"] as! Double,
            category: data["category"] as! String,
            created: data["created"] as! String,
            urls: data["urls"] as! [String]
        )
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
