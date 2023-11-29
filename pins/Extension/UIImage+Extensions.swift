//
//  UIImage.swift
//  pins
//
//  Created by 주동석 on 2023/11/29.
//

import UIKit

extension UIImage {
    func resizeImageTo40Percent() -> UIImage {
        let originalSize = self.size
        let scaleFactor: CGFloat = 0.4  // 40%로 크기 조정

        // 새로운 크기 계산
        let newSize = CGSize(width: originalSize.width * scaleFactor, height: originalSize.height * scaleFactor)

        // 새 이미지 컨텍스트를 생성하고 이미지를 그립니다.
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!
    }
}
