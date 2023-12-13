//
//  UIScreenUtils.swift
//  pins
//
//  Created by 주동석 on 2023/11/30.
//

import UIKit

enum UIScreenUtils {
    static func getScreenWidth() -> CGFloat {
        return getActiveWindow()?.bounds.width ?? UIScreen.main.bounds.width
    }
    
    static func getScreenHeight() -> CGFloat {
        return getActiveWindow()?.bounds.height ?? UIScreen.main.bounds.height
    }
    
    static func getScreenSize() -> CGSize {
        return getActiveWindow()?.bounds.size ?? UIScreen.main.bounds.size
    }

    private static func getActiveWindow() -> UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window 
            }
        }
        return nil
    }
}
