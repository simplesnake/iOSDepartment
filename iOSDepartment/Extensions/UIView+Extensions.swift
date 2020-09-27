//
//  UIView+Extensions.swift
//  iOSDepartment
//
//  Created by Александр Строев on 27.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit


// MARK: - Работа с анимациями
extension UIView {
    
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate360(roundDuration: Double = 1, times: Float = Float.infinity) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = roundDuration
            rotationAnimation.repeatCount = times

            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
}
