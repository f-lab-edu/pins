//
//  ImageCacheManager.swift
//  pins
//
//  Created by 주동석 on 12/19/23.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
