//
//  UIScreenUtils.swift
//  pins
//
//  Created by 주동석 on 2023/11/30.
//

import UIKit

enum UIScreenUtils {
    static func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
}
