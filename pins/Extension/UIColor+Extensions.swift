//
//  UIColor+Extensions.swift
//  pins
//
//  Created by 주동석 on 12/21/23.
//

import UIKit

extension UIColor {
    convenience init(asset: ColorAssets) {
        self.init(named: asset.rawValue)!
    }
}
