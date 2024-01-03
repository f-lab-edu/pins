//
//  AnimationManager.swift
//  pins
//
//  Created by 주동석 on 2023/11/21.
//

import UIKit
import QuartzCore

final class AnimationManager {
    func shakeAnimation() -> CABasicAnimation {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.fromValue = -0.15
        shakeAnimation.toValue = 0.15
        shakeAnimation.duration = 0.3
        shakeAnimation.repeatCount = Float.infinity
        shakeAnimation.autoreverses = true

        return shakeAnimation
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 2.0
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = 0.5

        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        return scaleAnimation
    }
    
    func keyboardAnimation(notification: Notification) -> (duration: TimeInterval, options: UIView.AnimationOptions) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        let curveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let curveRaw = curveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let options = UIView.AnimationOptions(rawValue: curveRaw)
        
        return (duration, options)
    }
}
