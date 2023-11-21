//
//  AnimationManager.swift
//  pins
//
//  Created by 주동석 on 2023/11/21.
//

import QuartzCore

enum AnimationManager {
    static func shakingAnimation() -> CABasicAnimation {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.fromValue = -0.15
        shakeAnimation.toValue = 0.15
        shakeAnimation.duration = 0.3
        shakeAnimation.repeatCount = Float.infinity
        shakeAnimation.autoreverses = true

        return shakeAnimation
    }
}
