//
//  UIImage.swift
//  pins
//
//  Created by 주동석 on 2023/11/29.
//

import UIKit

extension UIImage {
    func resizeImage(width: CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!
    }
}

extension UIImage {
    convenience init(asset: ImageAssets) {
        self.init(named: asset.rawValue)!
    }
}
