//
//  Data+Extensions.swift
//  pins
//
//  Created by 주동석 on 12/28/23.
//

import UIKit

extension Data {
    func toUIImage() -> UIImage {
        if let image = UIImage(data: self) {
            return image
        }
        fatalError("converting error data to image")
    }
}
